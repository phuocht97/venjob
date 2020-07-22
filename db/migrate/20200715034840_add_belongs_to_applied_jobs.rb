class AddBelongsToAppliedJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :job_applieds, :job_id, :bigint
    add_column :job_applieds, :user_id, :bigint
  end
end
