class CreateCategory < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name, null: false, limit: 50
      t.references :user, null: false
      t.datetime :created_at, null: false
    end

    add_index :categories, :name, unique: true
  end
end
