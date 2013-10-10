
require 'bundler/capistrano'
require 'sidekiq/capistrano'
require 'puma/capistrano'

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :host, 'gt2'
role :web, host                          # Your HTTP server, Apache/etc
role :app, host                          # This may be the same as your `Web` server
role :db,  host # This is where Rails migrations will run

set :ssh_options, {:forward_agent => true}
set :use_sudo, false

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

set :default_environment, {
  'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH"
}

namespace :deploy do
  task :migrate do; end
end

set :application, "gt2"
set :user, "sergio"
set :group, "www-data"

set :scm, :git
set :repository, "git@bitbucket.org:stulentsev/gt2.git"
set :branch, 'develop'
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache
set :rails_env, 'production'