module Linchpin
  module Network
    class MessageServer

      def initialize(socket, serializer = ObjectSerializer.new)
        @socket = socket
        @serializer = serializer
        @buffer = MessageBuffer.new
      end

      def pending_messages
        [].tap do |messages|
          receive_messages(messages)
        end
      end

      def respond(message)
        num_sent = 0
        loop do
          num_sent += send(message)
          break if message.size == num_sent
          message.slice!(num_sent, message.size - 1)
        end
      end

      private

      attr_reader :socket, :serializer, :buffer

      def receive_messages(messages)
        loop do
          self.buffer << socket.recv_nonblock(1024)

          if buffer.message_complete?
            messages << serializer.from_net(buffer.reset)
          end
        end
      rescue IO::WaitReadable
        # no data to receive, no op
      end
    end
  end
end
