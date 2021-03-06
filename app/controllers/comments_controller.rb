class CommentsController < ApplicationController
  before_filter :loggedin_user, only: [:create]
  before_filter :correct_user, only: [:update, :destroy]

  respond_to :html, :json
  
  def create
    #@course = Course.find(params[:course_id])
    @commentable_type = params[:comment][:commentable_type]
    @commentable_id = params[:comment][:commentable_id]
    @comment = current_user.comment!(@commentable_type, @commentable_id, params[:comment][:body])
    @commentable = @comment.commentable
    @comments = @commentable.comment_threads
    if @comment.save
      users = []
      users << @commentable.user
      users += @commentable.comment_threads.map(&:user)
      users.delete current_user
      users = users.uniq
      users.each do |u|
        u.add_notification!(@commentable, @comment, current_user)
      end
      respond_to do |format|
        format.html { redirect_to @commentable }
        format.js
      end
    else
      render 'new'
    end
  end

  def update
    @comment.update_attributes(params[:comment])
    respond_with @comment
  end

  def index
    @list = List.find(params[:list_id])
    @comments = @list.comment_threads
    @user = @list.user
    @lists = @user.lists.delete_if { |l| l.id == @list.id }.sort_by(&:created_at).reverse[0..5]
    @commentable_type = "List"
    @commentable_id = @list.id
  end

  def destroy
  	@commentable = @comment.commentable
    @commentable_type = @comment.commentable_type
    @commentable_id = @comment.commentable_id
    @comments = @commentable.comment_threads
    if @comment.destroy
      respond_to do |format|
        format.html { redirect_to @commentable }
        format.js
      end
    end
  end

private
  def correct_user
    @comment = current_user.comments.find_by_id(params[:id])
    redirect_to root_url if @comment.nil?
  end
end
