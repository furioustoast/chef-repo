package "mysql-server-5.0"

template "/etc/mysql/conf.d/skip-networking" do
  owner "root"
  group "root"
  mode  0644
  source "skip-networking.cnf.erb"
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
