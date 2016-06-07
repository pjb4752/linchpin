module Linchpin
  module ObjectSerializable
    def self.included(base)
      ObjectSerializer.serializable_classes << base
    end
  end

  class ObjectSerializer

    HEADER_SIZE = 3

    def self.serializable_classes
      @serializable_classes ||= Set.new
    end

    def to_net(object)
      serializable_check(object)

      data = Marshal.dump(object)
      data.prepend(format % data.size)
    end

    def from_net(data)
      serializable_check(object)

      data.slice!(0, header_size)
      Marshal.load(data)
    end

    def header_size
      HEADER_SIZE
    end

    private

    def format
      "%0#{header_size}x"
    end

    def serializable_check(object)
      if !serializable?(object)
        raise SerializationError, 'cannot serialize unregistered classes'
      end
    end

    def serializable?(object)
      self.class.serializable_classes.include?(object.class)
    end
  end
end
