class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string :name
      t.text :description
    end
    
    Beer.uniq.pluck(:style).each { |x| Style.create(name: x, description: "No description added") }
  end
end
