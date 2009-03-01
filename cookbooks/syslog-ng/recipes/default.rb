package "syslog-ng"

service "syslog-ng" do
  supports :restart => true
  action :enable
end

template "/etc/logrotate.d/syslog-ng-additions" do
  source "syslog-ng-additions.erb"
end

template "/usr/local/bin/logsplitter" do
  source "logsplitter.erb"
  mode 0755
end

template "/etc/syslog-ng/syslog-ng.conf" do
  source "syslog-ng.conf.erb"
  mode 0644
  notifies :restart, resources(:service => "syslog-ng")
end
