module Linchpin
  module Message
    class Result

      attr_reader :values

      def initialize(values)
        @values = values
      end
    end
  end
end
