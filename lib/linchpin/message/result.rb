require 'linchpin/object_serializer.rb'

module Linchpin
  module Message
    class Result
      include Linchpin::ObjectSerializable

      attr_reader :values

      def initialize(values)
        @values = values
      end
    end
  end
end
