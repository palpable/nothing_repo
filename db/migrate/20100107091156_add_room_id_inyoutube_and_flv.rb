class AddRoomIdInyoutubeAndFlv < ActiveRecord::Migration
  def self.up
    
    
      add_column :youtube_u_links,:room_id,:integer
    add_column :flvu_u_urls,:room_id,:integer
  end

  def self.down
    
     remove_column :youtube_u_links,:room_id
    remove_column :flvu_u_urls,:room_id
  end
end
