class RoomsController < ApplicationController
  

	def create
	@room = Room.new
    @room.save
    redirect_to rooms_path
	end


	def show
		@room = Room.find(params[:id])
		@messages = @room.messages.recent.limit(5).reverse
	end
end
