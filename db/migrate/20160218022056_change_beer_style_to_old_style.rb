class ChangeBeerStyleToOldStyle < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :beers do |t|
        dir.up   { t.rename :style, :old_style }
        dir.down { t.rename :old_style, :style }
      end
    end
  end
end
