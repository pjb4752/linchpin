module Linchpin
  module Network
    class ObjectSerializer

      def to_net(object)
        Marshal.dump(object)
      end

      def from_net(data)
        Marshal.load(data)
      end
    end
  end
end
