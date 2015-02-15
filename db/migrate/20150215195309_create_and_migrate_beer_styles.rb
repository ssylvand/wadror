class CreateAndMigrateBeerStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.text :description
      t.string :text
      t.timestamps null: false
    end
    change_table :beers do |t|
      t.rename :style, :old_style
      t.integer :style_id
    end
    
  end
end
