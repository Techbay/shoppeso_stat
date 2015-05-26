# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'shoppeso_stat'
set :repo_url, 'git@github.com:Techbay/shoppeso_stat.git'

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.2.2'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
 
# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call
 
set :user, "techbay"
# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
 
# Default value for :scm is :git
set :scm, :git
 
# Default value for :format is :pretty
set :format, :pretty
 
# Default value for :log_level is :debug
# set :log_level, :debug
 
# Default value for :pty is false
# set :pty, true
 
set :bundle_without,  [:development, :test]

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/application.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
 
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, { path: "~/.rbenv/shims:~/.rbenv/bin:$PATH" }
 
# Default value for keep_releases is 5
set :keep_releases, 5
 
set :use_sudo, false
set :rails_env, 'production'
set :depoly_via, :remote_cache
set :puma_config_path, -> { File.join(current_path, "config", "puma.rb") }
set :puma_pid,  -> { File.join(shared_path, "tmp", "pids", "puma.shoppesostat.pid") }

namespace :deploy do
  desc "Init the config files in shared_path"
  task :setup_config do        
    on roles(:all), in: :sequence, wait: 5 do
      unless test "[ -d #{shared_path}/config ]"
        execute "mkdir -p #{shared_path}/config"
        upload!("config/application.yml.example", "#{shared_path}/config/application.yml")
        puts "Now edit the config files in #{shared_path}"
      end                      
    end
  end
  after "check:directories", :setup_config

  desc 'Restart application'
  task :restart do
    on roles(:web), in: :sequence, wait: 10 do
      if test "[ -f #{fetch(:puma_pid)} ]"
        execute "kill -USR2 `cat #{fetch(:puma_pid)}`"
      else
        within current_path do
          execute :bundle, "exec puma", "--config", fetch(:puma_config_path), "-e", fetch(:rails_env), "-d"
        end
      end
      execute :bundle, "exec bin/delayed_job", "-n 1", "restart", "RAILS_ENV=production"
    end
  end
  after :publishing, :restart
  after :finishing, :cleanup
end
