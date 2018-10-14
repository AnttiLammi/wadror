class CreateStyles < ActiveRecord::Migration[5.2]
  def change
    create_table :styles do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
    remove_column :beers, :style, :string
    add_column :beers, :style_id, :integer
  end
end