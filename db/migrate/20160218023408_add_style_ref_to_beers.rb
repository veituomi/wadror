class AddStyleRefToBeers < ActiveRecord::Migration
  def change
    add_reference :beers, :style, index: true, foreign_key: true
    
    Beer.all.each { |x| x.update_attribute(:style, Style.find_by(name: x.old_style)) }
  end
end
