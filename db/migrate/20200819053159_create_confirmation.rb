class CreateConfirmation < ActiveRecord::Migration[5.2]
  def change
    create_table :confirmations, options: 'COLLATE=utf8_general_ci' do |t|
      t.string :email
      t.string :confirm_token

      t.timestamps
    end
  end
end
