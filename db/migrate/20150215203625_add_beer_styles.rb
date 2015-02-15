class AddBeerStyles < ActiveRecord::Migration
  def change
    change_table :beers do |t|
      t.integer :style_id
    end
    Beer.all.map { |b| b.old_style }.uniq.each do |s|
      Style.create style: s
    end
  end
end
