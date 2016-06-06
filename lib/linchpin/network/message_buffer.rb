module Linchpin
  module Network
    class MessageBuffer
      IncompleteMessageError = Class.new(StandardError)

      def initialize(header_size)
        @header_size = header_size
        @buffer = ''
      end

      def <<(data)
        @buffer << data
      end

      def message?
        message_header? && message_body?
      end

      def message
        raise IncompleteMessageError unless message?

        buffer.slice!(0, header_size + message_size)
      end

      private

      attr_reader :buffer, :header_size

      def message_header?
        buffer.size >= header_size
      end

      def message_body?
        header_size + message_size >= buffer.size
      end

      def message_size
        buffer[0...header_size].to_i(16)
      end
    end
  end
end
