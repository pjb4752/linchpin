#!/usr/bin/env ruby

require 'linchpin'
require 'linchpin/server'
require 'linchpin/message/control'
require 'linchpin/message/result'

def handle_message(message)
  case message
  when Linchpin::Message::Control
    Linchpin::Message::Result.new('control received')
  else
    Linchpin::Message::Result.new('unknown message')
  end
end

Linchpin::Server.unix_server do |server, messages|
  messages.each do |message|
    puts "handling message: #{message}"
    response = handle_message(message)

    server.respond(response)
  end
end
