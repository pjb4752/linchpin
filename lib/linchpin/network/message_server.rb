module Linchpin
  module Network
    class MessageServer

      def initialize(socket, serializer = ObjectSerializer.new)
        @socket = socket
        @serializer = serializer
        @buffer = MessageBuffer.new
      end

      def messages
        [].tap do |messages|
          receive(messages)
        end
      end

      def respond(message)
        net_data = serializer.to_net(message)
        net_data.prepend('%x' % net_data.size)

        send(net_data)
      end

      private

      attr_reader :socket, :serializer, :buffer

      def receive(messages)
        loop do
          self.buffer << socket.recv_nonblock(1024)

          if buffer.message_complete?
            messages << serializer.from_net(buffer.reset)
          end
        end
      rescue IO::WaitReadable
        # no data to receive, no op
      end

      def send(data)
        num_sent = 0
        loop do
          num_sent += socket.send(data)
          break if data.size == num_sent
          data.slice!(num_sent, data.size - 1)
        end
      end
    end
  end
end
