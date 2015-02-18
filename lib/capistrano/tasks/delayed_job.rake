namespace :delayed_job do

  def args
    fetch(:delayed_job_args, "")
  end

  def delayed_job_roles
    fetch(:delayed_job_server_role, :app)
  end

  desc 'Stop the delayed_job process'
  task :stop do
    on roles(delayed_job_roles) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          # execute :bundle, :exec, :'bin/delayed_job', :stop
          # execute :initctl, :stop, :delayed_job
          execute "sudo initctl stop delayed_job"
        end
      end
    end
  end

  desc 'Start the delayed_job process'
  task :start do
    on roles(delayed_job_roles) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          # execute :bundle, :exec, :'bin/delayed_job', args, :start
          # execute :initctl, :start, :delayed_job
          execute "sudo initctl start delayed_job"
        end
      end
    end
  end

  desc 'Restart the delayed_job process'
  task :restart do
    on roles(delayed_job_roles) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          # execute :bundle, :exec, :'bin/delayed_job', args, :restart
          # execute :initctl, :restart, :delayed_job
          execute "sudo initctl restart delayed_job"
        end
      end
    end
  end

end
