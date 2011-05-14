class AddColumnInRoadShow < ActiveRecord::Migration
  def self.up
    add_column :road_shows,:title,:string
    add_column :road_shows,:description,:text
  end

  def self.down
    remove_column :road_shows,:title
    remove_column :road_shows,:description
  end
end
