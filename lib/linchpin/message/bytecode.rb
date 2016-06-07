require 'linchpin/object_serializer.rb'

module Linchpin
  module Message
    class Bytecode
      include Linchpin::ObjectSerializable

      attr_reader :opcode, :operands

      def initialize(opcode, operands)
        @opcode = opcode
        @operands = operands
      end
    end
  end
end
