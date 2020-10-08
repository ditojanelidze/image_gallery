class CreateUser < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name,          null: false, limit: 50
      t.string :last_name,           null: false, limit: 50
      t.string :username,            null: false, limit: 50
      t.string :password,            null: false, limit: 200
      t.datetime :registration_date, null: false
    end
  end
end
