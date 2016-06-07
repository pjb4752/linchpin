require 'linchpin/object_serializer'
require 'linchpin/network/message_server'
require 'socket'

module Linchpin
  class Server

    def self.unix_server(path = '/tmp/linchpin.sock', &block)
      Socket.unix_server_socket(path) do |server|
        serializer = ObjectSerializer.new
        message_server = Network::MessageServer.new(server, serializer)
        linchpin_server = self.new(message_server)

        linchpin_server.run_server(&block)
      end
    end

    def initialize(message_server)
      @message_server = message_server
    end

    def run_server(&block)
      loop { handle_clients(&block) }
    end

    def messages
      message_server.messages
    end

    def respond(message)
      message_server.respond(message)
    end

    private

    attr_reader :message_server

    def handle_clients
      message_server.await_client

      loop { yield self }
    rescue Network::MessageServer::ClientDisconnect
      $stderr.puts 'client disconnected'
    end
  end
end
