class JobsController < ApplicationController
  def index
    @cities = City.all
    @industries = Industry.all
    @total_job = Job.count
    @jobs_list = Job.all_job.page(params[:page]).per(20)
  end
end
