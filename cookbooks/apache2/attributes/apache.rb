apache Mash.new unless attribute?("apache")
apache[:dir]     = "/etc/apache2"
apache[:servername] = "default"
apache[:user]    = "www-data"
apache[:binary]  = "/usr/sbin/apache2"
apache[:icondir] = "/usr/share/apache2/icons"
apache[:listen_ports] = %w(80)
apache[:contact] = "webmaster@furioustoast.com"
apache[:timeout] = 50
apache[:keepalive] = "On"
apache[:keepaliverequests] = 100
apache[:keepalivetimeout] = 15

apache[:worker] = Mash.new unless apache.has_key?(:worker)
apache[:worker][:startservers] = 1
apache[:worker][:maxclients] = 10
apache[:worker][:minsparethreads] = 1
apache[:worker][:maxsparethreads] = 1
apache[:worker][:threadsperchild] = 10
apache[:worker][:maxrequestsperchild] = 50000
apache[:worker][:threadstacksize] = 500000
