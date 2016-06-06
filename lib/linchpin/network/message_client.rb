require 'linchpin/network/message_buffer'

module Linchpin
  module Network
    class MessageClient

      def initialize(socket, serializer)
        @socket = socket
        @serializer = serializer
        @recv_buffer = MessageBuffer.new(serializer.header_size)
      end

      def call(message)
        send(message)
        receive
      end

      def send(message)
        net_data = serializer.to_net(message)
        send_complete(net_data, net_data.size)
      end

      def receive
        serializer.from_net(receive_complete)
      end

      private

      attr_reader :socket, :serializer, :recv_buffer

      def send_complete(data, size)
        loop do
          num_sent = socket.send(data, 0)
          data.slice!(0, num_sent)
          break if data.empty?
        end
      end

      def receive_complete
        loop do
          recv_buffer << socket.recv(1024, 0)
          break recv_buffer.message if recv_buffer.message?
        end
      end
    end
  end
end
