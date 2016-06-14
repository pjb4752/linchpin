require 'linchpin/serializable.rb'

module Linchpin
  module Message
    class Result
      include Linchpin::Serializable

      attr_reader :values

      def initialize(values)
        @values = values
      end
    end
  end
end
