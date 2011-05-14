class CentralbankList < ActiveRecord::Base
   validate do |cam|
    cam.errors.add_to_base("Country Name cannot be blank") if cam.country_name.blank?
    cam.errors.add_to_base("Bank Name cannot be blank") if cam.bank_name.blank?
    cam.errors.add_to_base("Url  cannot be blank") if cam.url_name.blank?
    
 end
 

  
end
