require 'linchpin/network/message_buffer'
require 'linchpin/network/message_queue'

module Linchpin
  module Network
    class MessageServer

      ClientDisconnect = Class.new(StandardError)

      def initialize(server, serializer)
        @server = server
        @serializer = serializer
        @recv_buffer = MessageBuffer.new(serializer.header_size)
        @send_queue = MessageQueue.new
      end

      def await_client
        socket, _ = server.accept
        self.socket = socket
      end

      def messages
        [].tap do |messages|
          receive(messages)
        end
      end

      def respond(message)
        net_data = serializer.to_net(message)
        send_complete(net_data, net_data.size)
      end

      def queue_response(message)
        net_data = serializer.to_net(message)
        self.send_queue << net_data
      end

      def attempt_response
        loop do
          break if send_queue.empty?
          sent = socket.sendmsg_nonblock(send_queue.data)
          send_queue.remove(sent)
        end
      rescue IO::WaitWritable
        # can't send data write now, no op
      end

      protected

      attr_reader :server, :serializer, :recv_buffer, :send_queue
      attr_accessor :socket

      def receive(messages)
        loop do
          data = socket.recv_nonblock(1024)
          raise ClientDisconnect if data.size == 0

          self.recv_buffer << data
          if recv_buffer.message?
            message = recv_buffer.message
            messages << serializer.from_net(message)
          end
        end
      rescue IO::WaitReadable
        # no data to receive, no op
      end

      def send_complete(data, size)
        loop do
          num_sent = socket.send(data, 0)
          data.slice!(0, num_sent)
          break if data.empty?
        end
      end
    end
  end
end
