set :application, "instant"

set :scm, "git"
set :repository,  "git@github.com:HakubJozak/instant.git"
set :keep_releases, 2
set :branch, "master"

set :user, "kuba"
set :deploy_to, "/home/kuba/instant"
set :use_sudo, false


#server "praha.inexsda.cz", :app, :web, :db, :primary => true
server "siven.onesim.net", :app, :web, :db, :primary => true


 namespace :deploy do
   desc "Restart Application"
   task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
   end

   desc "Symlink shared configs and folders on each release."
   task :symlink_shared do
   end

   after "deploy:update_code", "deploy:symlink_shared"
 end
