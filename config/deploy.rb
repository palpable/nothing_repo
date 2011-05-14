#############################################################
#	Application
#############################################################

set :application, "centralbank"
set :deploy_to, "/home/monkeyg/centralbank"

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
set :use_sudo, true
set :rails_env,    "production"

#############################################################
#	Servers
#############################################################

set :user, "root"
set :password, "shawn7851213"

set :domain, "cb.monkeypantsstudios.com"
role :app, "67.23.24.230"
role :web, "67.23.24.230"
role :db,"67.23.24.230"  , :primary => true

#############################################################
#	Subversion
#############################################################

set :repository,  "https://digitalsleep.svn.beanstalkapp.com/centralbank/trunk/central"

#set :svn_username, "palaniapk"
#set :svn_password, "palaniapk"
set :checkout, "export"

#############################################################
#	Passenger
#############################################################

namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    
    run <<-CMD
    rm -rf #{current_path}/public/uploads &&
    ln -s #{shared_path}/uploads #{current_path}/public/uploads
    CMD
    run "chown www-data -R #{current_path}/"
    run "chmod a+rw #{current_path}/uuid.state"
    run "touch #{current_path}/tmp/restart.txt"
     #run "/etc/init.d/nginx restart"
  end
end

#############################################################
#	Search Engine Restart-After Deploy
#############################################################

namespace :ultra_sphinx_restart do
  desc "Generate the Indexing UltraSphinx file"
  task :restart do
     run "cd #{current_path} && rake ultrasphinx:configure RAILS_ENV=production"
    run "cd #{current_path} && rake ultrasphinx:index RAILS_ENV=production"
    run "cd #{current_path} && rake ultrasphinx:daemon:start RAILS_ENV=production"
  end
end

#############################################################
#        Stop the search Engine  before deploy
#############################################################
namespace :ultra_sphinx_stop do
  desc "Stopping the UltraSphinx service"
  task :stop do
    run "cd #{current_path} && rake ultrasphinx:daemon:stop RAILS_ENV=production"
  end
end


after :deploy, "ultra_sphinx_restart:restart"
before :deploy, "ultra_sphinx_stop:stop"







