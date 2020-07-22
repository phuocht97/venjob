class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, :options => 'COLLATE=utf8_general_ci' do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :remember_token
      t.boolean :admin

      t.timestamps
    end
  end
end
