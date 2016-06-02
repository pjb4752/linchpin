require 'linchpin/network/object_serializer'
require 'linchpin/network/message_buffer'

module Linchpin
  module Network
    class MessageClient

      def initialize(socket, serializer = ObjectSerializer.new)
        @socket = socket
        @serializer = serializer
      end

      def call(data)
        send(data)
        receive
      end

      def send(data)
        net_data = serializer.to_net(data)
        net_data.prepend('%x' % net_data.size)

        send_complete(net_data, net_data.size)
      end

      def receive
        serializer.from_net(receive_complete)
      end

      private

      attr_reader :socket, :serializer

      def send_complete(message, size)
        loop do
          sent = socket.send(message)
          break if message.size == sent
          message.slice!(sent, message.length)
        end
      end

      def receive_complete
        buffer = MessageBuffer.new

        loop do
          buffer << socket.recv(1024, 0)
          break buffer.message if buffer.message_complete?
        end
      end
    end
  end
end
