user = "techbay"
application = "shoppeso_stat"
path = "/home/#{user}/apps/#{application}/shared"
 
port 5000
threads 0, 4
workers 1
worker_timeout 60
environment 'production'
daemonize true
prune_bundler

pidfile "#{path}/tmp/pids/puma.#{application}.pid"
state_path "#{path}/tmp/puma.#{application}.state"
stdout_redirect "#{path}/log/puma.stdout", "#{path}/log/puma.stderr", true

preload_app!
on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end 
end
