class CreateCheckLinks < ActiveRecord::Migration
  def self.up
    create_table :check_links do |t|
      t.column :name,:string
      t.column :icon,:string
      t.column :link ,:string
      t.timestamps
    end
=begin
    CentralbankList.reset_column_information
    lists= [["FaceBook","links/facebook.png","www.facebook.com"],["Bloomberg","links/Bloomberg.png","www.bloomberg.com"],["Linkedin","links/linkedin.jpg","www.linkedin.com"],
              ["Fox News","links/fox-news.jpg","www.foxnews.com"],["Dowjones","links/dowjones.gif","www.dowjones.com"],["BBC","links/bbc.png","www.bbc.co.uk"]
            ]
    lists.sort.each do |element|
      Link.create(:name => element[0], :icon => element[1], :link => element[2])
    end
=end
  end

  def self.down
    drop_table :check_links
  end
end
