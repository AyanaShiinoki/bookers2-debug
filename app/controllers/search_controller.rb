class SearchController < ApplicationController

def search
	method = params[:search_method]
	@word = params[:search_word]
	if params[:search_content] == "User"
		@users = User.search(method,@word)
	elsif params[:search_content] == "Book"
		@books = Book.search(method,@word)
	else
	end
	# 必要？？
	# ここで定義しないとエラー
	@book = Book.new
end


end
