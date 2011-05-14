class CheckLink < ActiveRecord::Base
  
    validate do |cam|
    cam.errors.add_to_base("Name cannot be blank") if cam.name.blank?
    cam.errors.add_to_base("Please attach an Icon") if cam.icon.blank?
    cam.errors.add_to_base("Link cannot be blank") if cam.link.blank?
    
  end

end
