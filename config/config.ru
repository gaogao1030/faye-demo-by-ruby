require 'json'
require 'faye'
require 'pry-rails'
Faye::WebSocket.load_adapter('thin')
class ServerAuth
  def incoming(message, callback)
    # Get subscribed channel and auth token
    return callback.call(message) if message['data'].nil?
    subscription = message['channel']
    msg_token    = message['data']['ext'] && message['data']['ext']['authToken']

    # Find the right token for the channel
    @file_content ||= File.read('./config/token.json')

    registry = JSON.parse(@file_content)
    token    = registry[subscription]

    # Add an error if the tokens don't match
    if token != msg_token
      message['error'] = 'Invalid subscription auth token'
    end

    # Call the server back now we're done
    message['data'].delete("ext")
    callback.call(message)
  end

  def outgoing(message, callback)
    # Carry on and send the message to the server
      callback.call(message)
  end
end




bayeux = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
bayeux.add_extension(ServerAuth.new)

run bayeux
