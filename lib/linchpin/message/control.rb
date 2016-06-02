module Linchpin
  module Message
    class Control

      attr_reader :code

      def initialize(code)
        @code = code
      end
    end
  end
end
