include_recipe "base"
include_recipe "apache2"
include_recipe "postfix"
include_recipe "mysql"
# Ruby 1.9 would go here
include_recipe "passenger"