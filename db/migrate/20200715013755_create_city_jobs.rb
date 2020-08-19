class CreateCityJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :city_jobs, options: 'COLLATE=utf8_general_ci' do |t|

      t.timestamps
    end
  end
end
