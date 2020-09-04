class HistoryJobsController < ApplicationController
  before_action :sign_in_validation, only: [:index]

  def index
    @count = current_user.histories.count
    @history_jobs = current_user.histories.order_history
  end
end
