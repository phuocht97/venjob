class AddBelongsToIndustryJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :industry_jobs, :job_id, :bigint
    add_column :industry_jobs, :industry_id, :bigint
  end
end
