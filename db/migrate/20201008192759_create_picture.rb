class CreatePicture < ActiveRecord::Migration[5.2]
  def change
    create_table :pictures do |t|
      t.string :image, null: false
      t.string :uuid, null: false, limit: 50
      t.references :category, null: false
      t.references :user, null: false
      t.integer :height, null: false
      t.integer :width, null: false
      t.datetime :created_at, null: false
    end
  end
end
