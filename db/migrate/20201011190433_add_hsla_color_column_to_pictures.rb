class AddHslaColorColumnToPictures < ActiveRecord::Migration[5.2]
  def change
    add_column :pictures, :hsla_color, :decimal, array: true, default: []
  end
end
