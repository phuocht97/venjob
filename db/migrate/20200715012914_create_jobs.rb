class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs, :options => 'COLLATE=utf8_general_ci' do |t|
      t.string :title
      t.text :description
      t.string :level
      t.string :salary
      t.string :experience
      t.string :expiration_date
      t.bigint :company_id
      t.timestamps
    end
  end
end
