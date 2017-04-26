class ChatroomsController < ApplicationController
  def show
    @messages = Message.most_recent
    @message  = Message.new
  end
end
