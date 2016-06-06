require 'linchpin/message/bytecode'
require 'linchpin/message/control'
require 'linchpin/message/result'

module Linchpin
  class ObjectSerializer

    HEADER_SIZE = 3

    def to_net(object)
      data = Marshal.dump(object)
      data.prepend(format % data.size)
    end

    def from_net(data)
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
  end
end
