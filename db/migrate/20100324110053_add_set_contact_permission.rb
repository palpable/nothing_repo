class AddSetContactPermission < ActiveRecord::Migration
  def self.up
    add_column :people,:contact_permission,:boolean,:default => true
  end

  def self.down
     remove_column :people,:contact_permission
  end
end
