class AddPhoneAndEmailVisibilityToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :phone_visibility, :boolean, :default => 1
    add_column :people, :email_visibility, :boolean, :default => 1
  end

  def self.down
    remove_column :people, :email_visibility
    remove_column :people, :phone_visibility
  end
end
