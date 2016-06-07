require 'linchpin/object_serializer.rb'

module Linchpin
  module Message
    class Control
      include Linchpin::ObjectSerializable

      attr_reader :code

      def initialize(code)
        @code = code
      end
    end
  end
end
