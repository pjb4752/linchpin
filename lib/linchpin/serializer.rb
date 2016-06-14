module Linchpin
  class Serializer
    SerializationError = Class.new(StandardError)

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
      data.slice!(0, header_size)
      Marshal.load(data)
    rescue ArgumentError
      raise_unserializable_error
    end

    def header_size
      HEADER_SIZE
    end

    private

    def format
      "%0#{header_size}x"
    end

    def serializable_check(object)
      raise_unserializable_error if !serializable?(object)
    end

    def raise_unserializable_error
      raise SeriazationError, 'cannot serialize unregistered classes'
    end

    def serializable?(object)
      self.class.serializable_classes.include?(object.class)
    end
  end
end
