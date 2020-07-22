class CreateHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :histories, :options => 'COLLATE=utf8_general_ci' do |t|

      t.timestamps
    end
  end
end
