class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :given_name
      t.string :sn
      t.integer :uid_number
      t.timestamps
    end
    add_index :users, :user_name, unique: true
    add_index :users, :uid_number, unique: true
  end
end
