package "postfix"

service "postfix" do
  supports :restart => true
  action :enable
end

template "/etc/mailname" do
  source "mailname.erb"
  variables({
    :fqdn => node[:fqdn]
  })
end

template "/etc/postfix/main.cf" do
  source "main.cf.erb"
  variables({:fqdn => node[:fqdn]})
  owner 'root'
  group 'root'
  mode 0644
  notifies :restart, resources(:service => "postfix")
end

