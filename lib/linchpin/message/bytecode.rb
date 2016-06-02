module Linchpin
  module Message
    class Bytecode

      attr_reader :opcode, :operands

      def initialize(opcode, operands)
        @opcode = opcode
        @operands = operands
      end
    end
  end
end
