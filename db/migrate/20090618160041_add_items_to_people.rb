class AddItemsToPeople < ActiveRecord::Migration
  def self.up
	add_column(:people, :isbanker, :integer) 
	add_column(:people, :company_name, :string)
	add_column(:people, :business_type, :string)
	add_column(:people, :country, :string)
	add_column(:people, :title, :string)
	add_column(:people, :department, :string)
  end

  def self.down
	remove_column(:people, :isbanker)
        remove_column(:people, :company_name)
        remove_column(:people, :business_type)
        remove_column(:people, :country)
        remove_column(:people, :title)
	remove_column(:people, :department)
  end
end
