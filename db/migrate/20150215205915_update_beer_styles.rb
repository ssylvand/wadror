class UpdateBeerStyles < ActiveRecord::Migration
  def change
    Beer.all.each do |b|
      b.style = Style.find_by style: b.old_style
      b.save
    end
    change_table :beers do |t|
      t.remove :old_style
    end
  end
end
