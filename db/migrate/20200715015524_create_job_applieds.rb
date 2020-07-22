class CreateJobApplieds < ActiveRecord::Migration[5.2]
  def change
    create_table :job_applieds, :options => 'COLLATE=utf8_general_ci' do |t|
      t.string :name
      t.string :email
      t.text :cv_user
      
      t.timestamps
    end
  end
end
