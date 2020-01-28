class Book < ApplicationRecord
	belongs_to :user
	#バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
	#presence trueは空欄の場合を意味する。
	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}
	has_many :favorites, dependent: :destroy
	has_many :post_comments, dependent: :destroy
	# 通知機能
	has_many :notifications, dependent: :destroy
	def favorited_by?(user)
          favorites.where(user_id: user.id).exists?
    end

	def self.search(method,word)
	    if method == "forward_match"
	        @books = Book.where("title LIKE?","#{word}%")
	    elsif method == "backward_match"
	        @books = Book.where("title LIKE?","%#{word}")
	    elsif method == "perfect_match"
	        @books = Book.where("title LIKE?","#{word}")
	    elsif method == "partial_match"
            @books = Book.where("title LIKE?","%#{word}%")
	    else
            @books = Book.all
	    end
  	end

  	# いいね通知の作成メソッド
  	def create_notification_fav!(current_user)
  		# すでにいいねされている？？
  		temp = Notification.where(["visitor_id = ? and visited_id = ? and book_id =? and action = ?",current_user.id,user_id, id, 'Favorite'])
  		# いいねされていない場合のみ、通知を作成
  		if temp.blank?
  			notification = current_user.active_notifications.new(
  				book_id: id,
  				visited_id: user_id,
  				action: 'fav'
  			)
  			# 自分の投稿に対する自分の言い値の場合は通知済みと設定
  			if notification.visitor_id == notification.visited_id
  				notification.checked = true
  			end
  			notification.save if notification.valid?
  		end
  	end

  	# コメント通知の作成メソッド
  	# def create_notification_comment!(current_user, post_comment_id)
  	# 	# 自分以外にコメントしている人を取得し、全員に通知を送る
  	# 	temp_ids = PostComment.select(:user_id).where(book_id: id).where.not(user_id: current_user.id).distinct
  	# 	temp_ids.each do |temp_id|
  	# 		save_notification_comment!(current_user,post_comment_id,temp_id['user_id'])
  	# 	end
  	# 	# まだ誰もコメントしていない場合は投稿者に通知を送る
  	# 	save_notification_comment!(current_user,post_comment_id).if temp_ids.blank?
  	# end

  	def save_notification_comment!(current_user, post_comment_id,visited_id)
  		# コメントは複数回することが考えられるため、一つの投稿に複数回通知する
  		notification = current_user.active_notifications.new(
  			book_id: id,
  			post_comment_id: post_comment_id,
  			visited_id: visited_id,
  			action: 'comment'
  			)
  		# 自分の投稿に対する自分のコメントは削除済み
  		if notification.visitor_id == notification.visited_id
  			notification.checked = true
  		end
  		notification.save if notification.valid?
  	end

  	# フォロー通知の作成メソッド
  	def create_notification_follow!(current_user)
  		temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ?",current_user.id,id,'follow'])
  		if tem.blank?
  			notification = current_user.active_notifications.new(
  				visited_id: id,
  				action: 'follow'
  				)
  			notification.save if notification.valid?
  		end
  	end
end
