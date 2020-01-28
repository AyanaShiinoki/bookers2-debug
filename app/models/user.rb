class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,:validatable

has_many :books
has_many :favorites, dependent: :destroy
has_many :post_comments, dependent: :destroy
attachment :profile_image, destroy: false

# 通知機能
has_many :active_notifications, class_name: 'Notification',foreign_key: 'visitor_id', dependent: :destroy
has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

# フォロー機能アソシエーション
has_many :following_relationships, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy
has_many :followings, through: :following_relationships
has_many :follower_relationships, foreign_key: "following_id", class_name: "Relationship", dependent: :destroy
has_many :followers, through: :follower_relationships

# フォロー機能メソッド

  def following?(other_user)
    following_relationships.find_by(following_id: other_user.id)
  end

  def follow!(other_user)
    following_relationships.create!(following_id: other_user.id)
  end

  def unfollow!(other_user)
    following_relationships.find_by(following_id: other_user.id).destroy
  end
  #バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
  validates :name, length: {maximum: 20, minimum: 2}
  validates :introduction, length: {maximum: 50}

    def self.search(method,word)
        if method == "forward_match"
            @users = User.where("name LIKE?","#{word}%")
        elsif method == "backward_match"
            @users = User.where("name LIKE?","%#{word}")
        elsif method == "perfect_match"
            @users = User.where("name LIKE?","#{word}")
        elsif method == "partial_match"
            @users = User.where("name LIKE?","%#{word}%")
        else
            @users = User.all
        end
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
