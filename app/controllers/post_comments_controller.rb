class PostCommentsController < ApplicationController

before_action :authenticate_user!

	def create
		book = Book.find(params[:book_id])
		comment = PostComment.new(post_comment_params)
		comment.user_id = current_user.id
		comment.book_id = book.id
		comment.save
		redirect_to book_path(book)
	end

	def destroy
		book = Book.find(params[:book_id]) #外部体から[:book_id]
		comment = PostComment.find_by(params[:id]) #コントローラ内なら(params[:id])
		if comment.user == current_user
		comment.destroy
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
