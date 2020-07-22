class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies, :options => 'COLLATE=utf8_general_ci' do |t|
      t.string :name
      t.text :address
      t.text :introduction
      
      t.timestamps
    end
  end
end
