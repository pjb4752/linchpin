require 'linchpin/serializable.rb'

module Linchpin
  module Message
    class Control
      include Linchpin::Serializable

      attr_reader :code

      def initialize(code)
        @code = code
      end
    end
  end
end
