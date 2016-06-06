module Linchpin
  module Network
    class MessageQueue

      attr_reader :data

      def initialize
        @data = ''
      end

      def <<(data)
        @data << data
      end

      def remove(num_items)
        data.slice!(0, num_items)
      end

      def empty?
        data.empty?
      end
    end
  end
end
