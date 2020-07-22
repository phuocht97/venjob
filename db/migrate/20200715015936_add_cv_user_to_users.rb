class AddCvUserToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :cv_user, :text 
  end
end
