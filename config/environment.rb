# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
#ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSIONl

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
# require 'rails_generator/secret_key_generator'

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
config.time_zone = 'UTC'
  # Add additional load paths for your own custom dirs
  config.load_paths += %W( #{RAILS_ROOT}/app/sweepers )
  config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir| 
    File.directory?(lib = "#{dir}/lib") ? lib : dir
  end


  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  secret_file = File.join(RAILS_ROOT, "secret")
  if File.exist?(secret_file)
    secret = File.read(secret_file)
  else
    secret = ActiveSupport::SecureRandom.hex(64)
    File.open(secret_file, 'w') { |f| f.write(secret) }
  end
  config.action_controller.session = {
    :session_key => '_instant_social_session',
    :secret      => secret
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # Custom gem requirements
  # config.gem 'mislav-will_paginate', :version => '~> 2.3.2',
  #                                    :lib => 'will_paginate',
  #                                    :source => 'http://gems.github.com'
  config.gem 'chronic', :version => '0.2.3'
  config.gem 'BlueCloth', :lib => 'bluecloth'
#  config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  config.gem 'gdata', :lib => 'gdata'
  

end

require 'vendor/plugins/jquery_ui_rails_helpers/helpers/tabs_renderer'



#require "smtp_tls"

ActionMailer::Base.smtp_settings = {
:address => "localhost",
:port => 25,
:domain => 'localhost',
:user_name => "sarang",
:password => "",
:authentication => :plain
}
#
#
#ActionMailer::Base.delivery_method = :smtp
#ActionMailer::Base.perform_deliveries = true
#ActionMailer::Base.raise_delivery_errors = true
#ActionMailer::Base.default_charset = "utf-8"
#ActionMailer::Base.default_content_type = "text/html"


ActionMailer::Base.raise_delivery_errors = false
ActionMailer::Base.delivery_method = :smtp
#ActionMailer::Base.smtp_settings = {
#                                    :address => "smtp.gmail.com",
#                                    :port => 587,
#                                    :domain => 'hellocompany.com',
#                                    :user_name => "jonhalk@gmail.com",
#                                    :password => 'abcxyz!@#123',
#                                    :authentication => :plain
#                                    }
#ActiveRecord::Base.default_timezone = :utc # Store all times in the db in UTC
#require 'tzinfo/lib/tzinfo' # Use tzinfo library to convert to and from the users timezone
#ENV['TZ'] = 'UTC' # This makes Time.now return time in UTC



# Set INLINEDIR to override default location for ruby_inline directory
# The home directory may not be correctly set in an "su"/"sudo" situation
# and will lead to runtime errors with image_science
#
# The directory /tmp/ruby.[USER] is used instead
ENV['INLINEDIR']="/tmp/ruby.#{ENV['USER']}" unless ENV['OS'] =~ /Windows/

require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'
