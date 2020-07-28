class TopPagesController < ApplicationController
  def index
    @total = Job.ids
  end
  def show
    @job = Job.all.order(created_at: :desc)
    @company = Company.all
  end
end
