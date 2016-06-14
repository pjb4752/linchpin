require 'linchpin/serializer'

module Linchpin
  module Serializable

    def self.included(base)
      Serializer.serializable_classes << base
    end
  end
end
