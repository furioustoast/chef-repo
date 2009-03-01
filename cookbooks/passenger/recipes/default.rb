include_recipe "base"

package "apache2-threaded-dev"

gem_package "passenger" do
  version node[:passenger_version]
end

execute "passenger_module" do
  command 'echo -en "\n\n\n\n" | passenger-install-apache2-module'
  creates node[:passenger][:module_path]
end

template node[:passenger][:apache_load_path] do
  source "passenger.load.erb"
  owner "root"
  group "root"
  mode 0755
  notifies :reload, resources(:service => "apache2")
end

template node[:passenger][:apache_conf_path] do
  source "passenger.conf.erb"
  owner "root"
  group "root"
  mode 0755
  notifies :reload, resources(:service => "apache2")
end

apache_module "passenger"

apache_site "000-default" do
  enable false
end

template "/usr/local/bin/apache_syslog" do
  source 'apache_syslog.erb'
  mode 0755
  owner 'root'
  group 'root'
end

if node[:applications]
  node[:applications].each do |app, config|
    template "/etc/apache2/sites-available/#{app}_#{config[:env]}" do
      owner 'root'
      group 'root'
      mode 0644
      source "application.vhost.erb"
      variables({
        :docroot => "/var/www/apps/#{app}/current/public",
        :server_name => config[:server_name],
        :max_pool_size => config[:max_pool_size] || 2,
        :env => config[:env],
        :aliases => config[:aliases],
        :app => app
      })
      notifies :reload, resources(:service => "apache2")
    end
    apache_site "#{app}_#{config[:env]}" do
      enable config[:enable]
    end
  end
end