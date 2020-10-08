class CreateCategory < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false, limit: 50
      t.references :user, null: false
      t.datetime :created_at, null: false
    end
  end
end
