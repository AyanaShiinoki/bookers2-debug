class RelationshipsController < ApplicationController


   def create
    @user = User.find(params[:relationship][:following_id])
    current_user.follow!(@user)

    # フォロー通知
    @user.create_notification_follow!(current_user)

    redirect_to request.referer
  end

  def destroy
    @user = Relationship.find(params[:id]).following
    current_user.unfollow!(@user)
    redirect_to request.referer
  end


end
