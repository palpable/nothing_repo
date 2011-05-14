class CreateDocattachments < ActiveRecord::Migration
  def self.up
    create_table :docattachments do |t|
      t.integer     :size, :height, :width, :parent_id, :attachable_id, :position
      t.string      :content_type, :filename, :thumbnail, :attachable_type
      t.timestamps
    end
    add_index :docattachments, :parent_id
    add_index :docattachments, [:attachable_id, :attachable_type]
  end

  def self.down
    drop_table :docattachments
  end
end
