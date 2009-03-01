# So imagine that you have an attribute mash named apache:
#   apache Mash.new unless attribute?("apache")
#
# And you'd like to prefer the values defined by the node over the defaults in your attributes file:
#   apache[:version] = '2.0.6' unless apache.has_key?(:version)
#
# Now instead of having to check every key you can do something like this:
#   apache Mash.new unless attribute?("apache")
#   apache.prefer_defaults = false
#   apache[:version] = '2.0.6'

class Mash
  attr_accessor :prefer_defaults
  @prefer_defaults = false

  hash_writer = instance_method('[]=')
  define_method('[]=') do |key,value|
    if prefer_defaults
      hash_writer.bind(self).call(key, value)
    else
      hash_writer.bind(self).call(key, value) unless has_key?(key)
    end
  end
end

