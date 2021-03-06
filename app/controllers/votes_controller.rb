class VotesController < ApplicationController
  before_filter :loggedin_user, only: [:new, :create, :destroy]
  before_filter :correct_user,  only: :destroy

  def create
  	@voteable_type      = params[:vote][:voteable_type]
    @voteable_id        = params[:vote][:voteable_id]
    @upvote_or_downvote = params[:vote][:vote] == "1"
    @vote = current_user.vote!(@upvote_or_downvote, @voteable_type, @voteable_id)
    if @vote
      @voteable = @vote.voteable
      if @voteable_type == "Comment"
        redirect_to @voteable.commentable
      else
        redirect_to @voteable
      end
    else
      render 'new'
    end
  end

  def destroy
    vote = @vote
  	@voteable = @vote.voteable
    if @vote.destroy
      if vote.voteable_type == "Comment"
        redirect_to @voteable.commentable
      else
        redirect_to @voteable
      end
    end
  end

private
  def correct_user
    @vote = current_user.votes.find_by_id(params[:id])
    redirect_to root_url if @vote.nil?
  end


end
