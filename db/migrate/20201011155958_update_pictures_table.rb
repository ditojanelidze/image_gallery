class UpdatePicturesTable < ActiveRecord::Migration[6.0]
  def change
    add_reference :pictures, :attached_to, foreign_key: {to_table: :pictures}
  end
end
