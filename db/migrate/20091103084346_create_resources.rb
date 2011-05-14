class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.string :name
      t.string :email
      t.integer :telephone
      t.string :fax_number
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :website
      t.string :issuers_type
      t.timestamps
    end
  end
  
  def self.down
    drop_table :resources
  end
end
