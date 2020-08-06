class CreateIndustries < ActiveRecord::Migration[5.2]
  def change
    create_table :industries, :options => 'COLLATE=utf8_general_ci' do |t|
      t.string :name
      t.string :converted_name

      t.timestamps
    end
  end
end
