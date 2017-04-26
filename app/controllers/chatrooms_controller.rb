class ChatroomsController < ApplicationController
  before_action :require_user

  def show
    @messages = Message.most_recent
    @message  = Message.new
  end
end
