require 'linchpin/object_serializer'
require 'linchpin/network/message_client'
require 'socket'

module Linchpin
  class Client

    ConnectError = Class.new(StandardError)

    def self.unix_client(path = '/tmp/linchpin.sock')
      socket = UNIXSocket.new(path)
      serializer = ObjectSerializer.new
      client = Network::MessageClient.new(socket, serializer)

      self.new(client)
    rescue Errno::ENOENT
      raise ConnectError,
        "couldn't connect to '#{path}'; is the server running?"
    end

    def initialize(message_client)
      @message_client = message_client
    end

    def send_control(control)
      message_client.call(control)
    end

    def exec(bytecode)
      message_client.call(bytecode)
    end

    private

    attr_reader :message_client

  end
end
