# TODO: refactor this... it's really ugly but it gets the job done

require 'chef/log'
require 'chef/mixin/command'
require 'chef/provider'

class Chef
  class Provider
    class Environment < Chef::Provider
      include Chef::Mixin::Command

      def load_current_resource
        @current_resource = Chef::Resource::Environment.new(@new_resource.name)
      end

      def action_prepend
        variable_name = @current_resource.name
        file = "/etc/environment"
        env = ::File.read(file)
        variable_regex = /#{variable_name}=\"([^"]*)\"/
        split_on = ':'
        values = variable_regex.match(env)[1].split(split_on)

        unless values.include?(@new_resource.value)
          env.gsub!(variable_regex) do |_|
            values.unshift @new_resource.value
            %(#{variable_name}="#{values.join(split_on)}")
          end
          Chef::Log.info("Prepending #{@new_resource.value} to #{@new_resource.name}")
          ::File.open(file, 'w+') do |f| ;f.write env; end
          @new_resource.updated = true
        end
      end

    end
  end
end

require 'chef/resource'

class Chef
  class Resource
    class Environment < Chef::Resource
      def initialize(name, collection=nil, node=nil)
        super(name, collection, node)
        @resource_name = :environment
        @value = nil
        @action = :prepend
        @allowed_actions.push(:prepend)
      end

      def value(arg=nil)
        set_or_return(:value, arg, :kind_of => String)
      end

    end
  end
end

Chef::Platform.set(:resource => :environment, :provider => Chef::Provider::Environment)
