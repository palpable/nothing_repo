class Docattachment < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  has_attachment     :storage => :file_system,
                     :thumbnails => { :bigthumb => '400>', :thumb => '120>', :tiny => '50>' },
                     :path_prefix => 'public/uploads',
                     :max_size => 100.megabyte
                   
  acts_as_state_machine :initial => :pending
  state :pending
  state :converting
  state :converted, :enter => :set_new_filename
  state :error
def rename_file
    true
  end
  event :convert do
    transitions :from => :pending, :to => :converting
  end

  event :converted do
    transitions :from => :converting, :to => :converted
  end

  event :failure do
    transitions :from => :converting, :to => :error
  end

   # This method is called from the controller and takes care of the converting
  def convert
    self.convert!
    spawn do
      success = system(convert_command)
      if success && $?.exitstatus == 0
        self.converted!
      else
        self.failure!
      end
    end # spawn
  end

  protected

  def convert_command

  #construct new file extension
     flv =  "." + id.to_s + ".flv"
      img = "." + "#{id}.jpg"
     # flv = File.join(File.dirname(RAILS_ROOT + '/public' +public_filename ),"#{id}.flv")
      # File.open(flv,'w')
  
  #build the command to execute ffmpeg
    command = <<-end_command
   
   ffmpeg  -y -i #{RAILS_ROOT + '/public' +public_filename} -ar 22050 -s 480x360 -qscale 5 -f flv #{RAILS_ROOT + '/public' + public_filename + flv};
   ffmpeg -i #{RAILS_ROOT + '/public' +public_filename} -f image2 -vframes 1  #{RAILS_ROOT + '/public' + public_filename + img};
    end_command
    #command.gsub!(/\s+/," ")
   end

  # This updates the stored filename with the new flash video file
  def set_new_filename
    update_attribute(:filename, "#{filename}.#{id}.flv")
    update_attribute(:content_type, "video/x-flv")
  end






end
