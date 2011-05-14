class AddpersoninInDocAttachementandRoadShow < ActiveRecord::Migration
  def self.up
    add_column :road_shows,:person_id,:integer
    add_column :docattachments,:person_id,:integer

  end

  def self.down
    remove_column :road_shows,:person_id
    remove_column :docattachments,:person_id
  end
end
