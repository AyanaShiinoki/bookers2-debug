class ChatBroadcastJob < ApplicationJob
  queue_as :default

  def perform(chat)
    # Do something later
    ActionCable.server.broadcast "room_channel_#{chat.room_id}", chat: render_chat(chat)
  end
   private

    def render_direct_message(chat)
      ApplicationController.renderer.render partial: 'chats/chat', locals: { chat: chat }
    end
end
