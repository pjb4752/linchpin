module Linchpin
  module Network
    class MessageBuffer
      IncompleteMessageError = Class.new(StandardError)

      HEADER_SIZE = 3

      def initialize
        @buffer = ''
      end

      def <<(data)
        @buffer << data
      end

      def message_complete?
        message_header_complete? && message_size_matches?
      end

      def message
        if message_complete?
          buffer[HEADER_SIZE..buffer.size]
        else
          raise IncompleteMessageError
        end
      end

      private

      attr_reader :buffer

      def message_header_complete?
        buffer.size > HEADER_SIZE
      end

      def message_size_matches?
        buffer[0..HEADER_SIZE].to_i(16) + HEADER_SIZE == buffer.size
      end
    end
  end
end
