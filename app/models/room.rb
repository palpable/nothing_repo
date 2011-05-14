class Room < ActiveRecord::Base

  has_many  :docattachments, :as => :attachable, :dependent => :destroy
  has_many :youtube_u_links
  has_many :flvu_u_urls
  belongs_to :person
  is_indexed :fields => [ 'title' ],
         :include => [{:association_name => 'person', :field => 'name', :as => 'person_name'}]
 
end
