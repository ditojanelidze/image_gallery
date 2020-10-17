class UpdatePicturesTable < ActiveRecord::Migration[5.2]
  def change
    add_reference :pictures, :attached_to, foreign_key: {to_table: :pictures}
  end
end
