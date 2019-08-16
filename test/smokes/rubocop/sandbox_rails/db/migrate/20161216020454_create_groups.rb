class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :group_name
      t.integer :gid_number
      t.string :description
      t.timestamps
    end
    add_index :groups, :group_name, unique: true
    add_index :groups, :gid_number, unique: true
  end
end
