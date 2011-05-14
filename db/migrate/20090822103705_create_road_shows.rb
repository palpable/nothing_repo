class CreateRoadShows < ActiveRecord::Migration
  def self.up
    create_table :road_shows do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :road_shows
  end
end
