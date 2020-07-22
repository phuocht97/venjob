class AddBelongsToCityJob < ActiveRecord::Migration[5.2]
  def change
    add_column :city_jobs, :job_id, :bigint
    add_column :city_jobs, :city_id, :bigint
  end
end
