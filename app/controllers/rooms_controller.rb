class RoomsController < ApplicationController
	before_action :authenticate_user!
	def show
		@room = Room.find(params[:id])
		if UserRoom.where(:user_id => current_user.id, :room_id => @room.id).present?
			@chats = @room.chats
			@userRooms = @room.chats
		else
			redirect_back(fallback_location: root_path)
		end
	end

	def create
		@room = Room.create(:name=> "DM")
		@userRoom1 = UserRoom.create(:room_id => @room.id, :user_id => current_user.id)
		@userRoom2 = UserRoom.create(params.require(:userRoom).permit(:user_id, :room_id).merge(:room_id => @room.id))
		redirect_to room_path(@room.id)
	end
end
