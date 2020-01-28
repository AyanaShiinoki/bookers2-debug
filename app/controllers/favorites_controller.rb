class FavoritesController < ApplicationController

	def create
		@book = Book.find(params[:book_id])
		favorite = @book.favorites.new(user_id: current_user.id)
		# favorite = current_user.favorites.new(book_id: @book.id)
		favorite.save

		# お気に入り通知
		@book.create_notification_fav!(current_user)


		# redirect_back(fallback_location: root_path)
	end

	def destroy
		@book = Book.find(params[:book_id])
		favorite = current_user.favorites.find_by(book_id: @book.id)
		favorite.destroy
		# redirect_back(fallback_location: root_path)
	end

end
