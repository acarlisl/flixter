class Instructor::SectionsController < ApplicationController
  # Ensures a user is already logged in before accessing these actions
  before_action :authenticate_user!
  before_action :require_authorized_for_current_course

  def new
    @section = Section.new
  end

  def create
    @section = current_course.sections.create(section_params)
    redirect_to instructor_course_path(current_course)
  end

  private

  # Checks that the user attempting to modify this course
  # is the owner of the course
  def require_authorized_for_current_course
    if current_course.user != current_user
      render plain: "Unauthorized", status: :unauthorized
    end
  end

  # Finds the current course in the DB if not already found
  helper_method :current_course
  def current_course
    @current_course ||= Course.find(params[:course_id])
  end

  def section_params
    params.require(:section).permit(:title)
  end
end
