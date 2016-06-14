require 'linchpin/serializable.rb'

module Linchpin
  module Message
    class Bytecode
      include Linchpin::Serializable

      attr_reader :opcode, :operands

      def initialize(opcode, operands)
        @opcode = opcode
        @operands = operands
      end
    end
  end
end
