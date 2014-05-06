require "bundler/capistrano"
require "rvm/capistrano"
require "delayed/recipes"
# require 'capistrano_colors'

set :application, "scoutz"
set :repository,  "."

set :use_sudo, false

set :asset_env, ""

set :shared_children, shared_children + %w{public/uploads}


# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# role :web, "desertsol-apps.net"                          # Your HTTP server, Apache/etc
# role :app, "desertsol-apps.net"                          # This may be the same as your `Web` server
# role :db,  "desertsol-apps.net", :primary => true # This is where Rails migrations will run
role :web, "192.168.0.2"                          # Your HTTP server, Apache/etc
role :app, "192.168.0.2"                          # This may be the same as your `Web` server
role :db,  "192.168.0.2", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

set :user, "karl"
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :copy
set :git_shallow_clone, 1

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# for delayed job worker
after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"


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


namespace :deploy do
  namespace :assets do
    desc 'Run the precompile task locally and rsync with shared'
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if releases.length <= 1 || capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        %x{bundle exec rake assets:precompile}
        %x{rsync --recursive --times --rsh=ssh --compress --human-readable --progress public/assets #{user}@#{host}:#{shared_path}}
        %x{bundle exec rake assets:clean}
      else
        logger.info 'Skipping asset pre-compilation because there were no asset changes'
      end
    end
  end
end
