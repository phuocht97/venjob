class CreateFavoriteJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_jobs, options: 'COLLATE=utf8_general_ci' do |t|

      t.timestamps
    end
  end
end
