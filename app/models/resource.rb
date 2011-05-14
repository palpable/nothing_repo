class Resource < ActiveRecord::Base
  
  before_save :http_website
  
  MAX_NAME = 40
  MAX_ADDRESS = 100
  MAX_CITY = 40
  MAX_STATE = 40
  MAX_COUNTRY = 40
  MAX_TELE = 15
  EMAIL_REGEX = /\A[A-Z0-9\._%+-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}\z/i
  
  validates_presence_of     :name, :telephone, :address, :city, :state, :country, :website, :issuers_type
  validates_length_of       :name,  :maximum => MAX_NAME, :message => "Too long with name" 
  validates_length_of       :address,  :maximum => MAX_ADDRESS, :message => "Too long with address" 
  validates_length_of       :city,  :maximum => MAX_CITY, :message => "Too long with city" 
  validates_length_of       :state,  :maximum => MAX_STATE, :message => "Too long with state" 
  validates_length_of       :country,  :maximum => MAX_COUNTRY, :message => "Too long with country" 
  validates_format_of       :email,
                            :with => EMAIL_REGEX,
                            :message => "must be a valid email address"
  validates_uniqueness_of   :email
  validates_numericality_of :telephone
  validates_length_of       :telephone,  :maximum => MAX_TELE, :message => "Too long with telephone. Must be between 7-20 characters"
  validates_numericality_of :fax_number, :allow_nil => true  
  
  def http_website
    if self.website and not self.website =~ /^(http:\/\/|https:\/\/|ftp:\/\/)/
      self.website = 'http://' + website
    end
    if self.website == "http://"
      self.website = nil
    end
  end
  
end
