class ChatroomsController < ApplicationController
  def show
    @messages = Message.all
    @message  = Message.new
  end
end
