class PostCommentsController < ApplicationController

before_action :authenticate_user!

	def create
		@book = Book.find(params[:book_id])
		@post_comment = PostComment.new(post_comment_params)
		@post_comment.user_id = current_user.id
		@post_comment.book_id = @book.id
		@post_comment.save
		# redirect_to book_path(book)
	end

	def destroy
		book = Book.find(params[:book_id]) #外部体から[:book_id]
		post_comment = PostComment.find_by(params[:id]) #コントローラ内なら(params[:id])
		if post_comment.user == current_user
		post_comment.destroy
		redirect_to request.referer
		else
		redirect_to request.referer
		end
	end


	private
	def post_comment_params
		params.require(:post_comment).permit(:user_id,:book_id,:comment)
	end
end
