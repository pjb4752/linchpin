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
        num_sent = 0
        loop do
          num_sent += socket.send(message)
          break if message.size == num_sent
          message.slice!(num_sent, message.size - 1)
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
