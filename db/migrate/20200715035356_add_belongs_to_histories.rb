class AddBelongsToHistories < ActiveRecord::Migration[5.2]
  def change
    add_column :histories, :job_id, :bigint
    add_column :histories, :user_id, :bigint
  end
end
