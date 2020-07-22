class AddBelongsToFavoriteJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :favorite_jobs, :job_id, :bigint
    add_column :favorite_jobs, :user_id, :bigint
  end
end
