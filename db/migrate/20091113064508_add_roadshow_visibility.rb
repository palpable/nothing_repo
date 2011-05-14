class AddRoadshowVisibility < ActiveRecord::Migration
  def self.up
      add_column :road_shows,:is_public,:boolean ,:default => false
  end

  def self.down
    remove_column :road_shows,:is_public
  end
end
