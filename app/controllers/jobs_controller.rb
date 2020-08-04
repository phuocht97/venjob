class JobsController < ApplicationController
  def index
    @total_job = Job.count
    @jobs_list = Job.all_job
  end
end
