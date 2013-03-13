require "bundler/capistrano"
require "rvm/capistrano"

set :application, "scoutz"
set :repository,  "."

set :use_sudo, false

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "desertsol-apps.net"                          # Your HTTP server, Apache/etc
role :app, "desertsol-apps.net"                          # This may be the same as your `Web` server
role :db,  "desertsol-apps.net", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

set :user, "karl"
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :copy
set :git_shallow_clone, 1

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

before 'deploy:assets:precompile', 'deploy:symlink_db'

namespace :deploy do
  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end
end
