class TopPagesController < ApplicationController
  def index
    @total = Job.ids
  end
  def show
    @job = Job.all
    @company = Company.all
  end
end
