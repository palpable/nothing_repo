class AdminSetting < ActiveRecord::Base
  
  def self.update_business_types(business_types)
    business_types.each do |business_type|
      create(:title => 'business_type', 
             :value => business_type
            ) if find_by_title_and_value('business_type', business_type).blank?
    end unless business_types.blank?
  end
end
