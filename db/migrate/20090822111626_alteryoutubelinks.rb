class Alteryoutubelinks < ActiveRecord::Migration
  def self.up
    add_column :youtube_u_links,:person_id,:integer
  end

  def self.down
    remove_column :youtube_u_links,:person_id
  end
end
