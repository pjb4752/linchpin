#!/usr/bin/env ruby

require 'linchpin'
require 'linchpin/client'
require 'linchpin/message/control'

def create_client
  Linchpin::Client.unix_client
end

def create_control(data)
  Linchpin::Message::Control.new(data)
end

begin
  client = create_client

  2.times do
    control = create_control(:globals)
    puts "sending: #{control}"
    response = client.send_control(control)
    puts "response: #{response}"
  end
rescue Linchpin::Client::ConnectError => cce
  $stderr.puts cce.message
end
