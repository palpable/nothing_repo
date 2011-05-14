class AddRoadShowIdInyoutubeAndFlv < ActiveRecord::Migration
  def self.up
    add_column :youtube_u_links,:road_show_id,:integer
    add_column :flvu_u_urls,:road_show_id,:integer
  end

  def self.down
    remove_column :youtube_u_links,:road_show_id
    remove_column :flvu_u_urls,:road_show_id
  end
end
