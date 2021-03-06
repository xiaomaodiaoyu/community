class EnrollmentsController < ApplicationController
  before_filter :loggedin_user, only: [:create, :destroy]

  def create
    @course = Course.find(params[:enrollment][:course_id])
    status = match_status(params[:enrollment][:status].to_sym)
    tags = params[:enrollment][:tags]
    @enrollment = current_user.enrollments.find_by_course_id(@course.id)
    if @enrollment
      @enrollment.update_attributes(status: status,
                                    tag_list: tags)
    else
      current_user.enroll!(@course, status, tags)
    end
    respond_to do |format|
      format.html { redirect_to @course }
      format.js
    end
  end

  def destroy
    @enrollment = Enrollment.find(params[:id])
    @course = @enrollment.course
    @enrollment.destroy
    redirect_to @course
  end

private
  def match_status(status_symbol)
    h = Hash[interested: 1, taking: 2, taken:3]
    h[status_symbol]
  end 
end
