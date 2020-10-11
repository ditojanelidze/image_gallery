class AddHslaColorColumnToPictures < ActiveRecord::Migration[6.0]
  def change
    add_column :pictures, :hsla_color, :decimal, array: true, default: []
  end
end
