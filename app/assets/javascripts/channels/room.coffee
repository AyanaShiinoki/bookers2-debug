document.addEventListener 'turbolinks:load', ->
  App.room = App.cable.subscriptions.create { channel: "RoomChannel", room: $('#chats').data('room_id') },
    connected: ->

    disconnected: ->

    received: (data) ->
      $('#chats').append data['chat']

    speak: (chat) ->
      @perform 'speak', chat: chat

  $('#chat-input').on 'keypress', (event) ->
    if event.keyCode is 13
      App.room.speak event.target.value
      event.target.value = ''
      event.preventDefault()








# App.room = App.cable.subscriptions.create "RoomChannel",
#   connected: ->
#     # Called when the subscription is ready for use on the server

#   disconnected: ->
#     # Called when the subscription has been terminated by the server

#   received: (data) ->
#   	$('#chats').append data['chat']
#     # Called when there's incoming data on the websocket for this channel

#   speak: (chat)->
#     @perform 'speak', chat: chat

#   $('#chat-input').on 'keypress', (event) ->
#     if event.keyCode is 13
#       App.room.speak event.target.value
#       event.target.value = ''
#       event.preventDefault()
