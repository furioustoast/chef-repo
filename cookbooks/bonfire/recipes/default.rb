# Note: Pretty much everything in this cookbook should
# be extracted out into a generic 'applications' cookbook
# -- but for now, we'll play around here.

node[:applications] = {
  :bonfire => {
    :server_name => 'bonfirenow.com',
    :aliases => %w(www.bonfirenow.com),
    :env => 'production',
    :enable => true
  }
}

include_recipe "rails_passenger"

node['user'] = 'deploy'

user node['user'] do
  comment "Deploy"
  uid "1000"
  gid "www-data"
  home "/home/deploy"
  shell "/bin/bash"
  # From makepasswd
  password "$1$JcizwzrY$K6p2kU.tQqc2vGrxGvPyh1"
  supports(:manage_home => true)
end

directory "/home/#{node[:user]}" do
  owner node[:user]
  mode 0755
end

directory "/var/www/apps" do
  owner node[:user]
  mode 0755
  recursive true
end

node[:applications].each do |app, _|
  
  cap_directories = [
    "/var/www/apps/#{app}",
    "/var/www/apps/#{app}/shared",
    "/var/www/apps/#{app}/shared/config",
    "/var/www/apps/#{app}/shared/system",
    "/var/www/apps/#{app}/releases"
  ]
  
  cap_directories.each do |dir|
    directory dir do
      owner node[:user]
      mode 0755
      recursive true
    end
  end
  
  bash "create_#{app}_production_db" do
    code %(mysql -u root --password=`cat /etc/mysql/.r` -e 'create database if not exists #{app}_production;')
  end
  
end

bash "set_root_password" do
  pass = generate_password(10)
  pass_file = '/etc/mysql/.r'
  cmds = []
  cmds << %(mysql -u root -e "SET PASSWORD FOR 'root'@'#{node[:hostname]}' = PASSWORD('#{pass}');
              SET PASSWORD FOR 'root'@'localhost' = PASSWORD('#{pass}');")
  cmds << "echo '#{pass}' > #{pass_file}"
  cmds << "chmod 400 #{pass_file}"

  code cmds.join(' && ')
  not_if { File.exists?(pass_file) }
end

template "/home/deploy/.gemrc" do
  source "gemrc.erb"
end

gem_package("abstract") { version bonfire[:abstract_version] }
gem_package("actionmailer") { version bonfire[:actionmailer_version] }
gem_package("actionpack") { version bonfire[:actionpack_version] }
gem_package("activerecord") { version bonfire[:activerecord_version] }
gem_package("activeresource") { version bonfire[:activeresource_version] }
gem_package("activesupport") { version bonfire[:activesupport_version] }
gem_package("daemons") { version bonfire[:daemons_version] }
gem_package("erubis") { version bonfire[:erubis_version] }
gem_package("eventmachine") { version bonfire[:eventmachine_version] }
gem_package("extlib") { version bonfire[:extlib_version] }
gem_package("fastthread") { version bonfire[:fastthread_version] }
gem_package("fiveruns-dash-rails") { version bonfire[:fiveruns_dash_rails_version] }
gem_package("fiveruns-dash-ruby") { version bonfire[:fiveruns_dash_ruby_version] }
gem_package("fiveruns-memcache-client") { version bonfire[:fiveruns_memcache_client_version] }
gem_package("fiveruns-starling") { version bonfire[:fiveruns_starling_version] }
gem_package("hoe") { version bonfire[:hoe_version] }
gem_package("hpricot") { version bonfire[:hpricot_version] }
gem_package("json") { version bonfire[:json_version] }
gem_package("json_pure") { version bonfire[:json_pure_version] }
gem_package("mailfactory") { version bonfire[:mailfactory_version] }
gem_package("merb-core") { version bonfire[:merb_core_version] }
gem_package("merb-mailer") { version bonfire[:merb_mailer_version] }
gem_package("mime-types") { version bonfire[:mime_types_version] }
gem_package("mojombo-god") { version bonfire[:mojombo_god_version] }
gem_package("mysql") { version bonfire[:mysql_version] }
gem_package("passenger") { version bonfire[:passenger_version] }
gem_package("rack") { version bonfire[:rack_version] }
gem_package("rails") { version bonfire[:rails_version] }
gem_package("rake") { version bonfire[:rake_version] }
gem_package("rspec") { version bonfire[:rspec_version] }
gem_package("rubyforge") { version bonfire[:rubyforge_version] }
gem_package("shuber-attr_encrypted") { version bonfire[:shuber_attr_encrypted_version] }
gem_package("shuber-eigenclass") { version bonfire[:shuber_eigenclass_version] }
gem_package("shuber-encryptor") { version bonfire[:shuber_encryptor_version] }
gem_package("simple-rss") { version bonfire[:simple_rss_version] }
gem_package("sqlite3-ruby") { version bonfire[:sqlite3_ruby_version] }
gem_package("SyslogLogger") { version bonfire[:SyslogLogger_version] }
gem_package("thor") { version bonfire[:thor_version] }
gem_package("tinder") { version bonfire[:tinder_version] }
gem_package("tmail") { version bonfire[:tmail_version] }
gem_package("twitter4r") { version bonfire[:twitter4r_version] }
