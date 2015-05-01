# http://stackoverflow.com/questions/6274126/how-to-compare-keys-in-yaml-files/6274367#6274367

require 'rubygems'
require 'yaml'
require 'pp'

# http://stackoverflow.com/questions/15744195/set-hash-value-at-arbitrary-location
def replace_nested_value_by(h, keys, newkey, value)
  h[keys.first] = Hash.new unless h.has_key?(keys.first)
  if keys.size > 1
    replace_nested_value_by(h[keys.first], keys[1..-1], newkey, value)
  elsif keys.size == 1
    h[keys.first][newkey] = value
  end
end

def add_value(val, context)
  d = @data
  context.each do |k,v|
    puts "Ctx " + k
    if d.has_key?(k) 
        d = d[k] 
    end
  end
  d = val
end

def compare_yaml_hash(cf1, cf2, context = [])
  cf1.each do |key, value|

    unless cf2.key?(key)
      puts "Missing key : #{key} in path #{context.join(".")}" 
      # add_value(value, context)
      replace_nested_value_by(@data, context, key, value)
      next
    end

    value2 = cf2[key]
     if (value.class != value2.class)
       puts "Key value type mismatch : #{key} in path #{context.join(".")}" 
       next
     end

    if value.is_a?(Hash)
      compare_yaml_hash(value, value2, (context + [key]))  
      next
    end

#    if (value != value2)
#      puts "Key value mismatch : #{key} in path #{context.join(".")}" 
#    end    
  end
end

lang = ARGV[0]
files = ['client', 'server']
files.each do |name|
	
    f1 = YAML.load_file("../../config/locales/#{name}.en.yml")
    f2 = YAML.load_file("../../config/locales/#{name}.#{lang}.yml")

    @data = Hash.new
    @data[lang] = Hash.new

    compare_yaml_hash(f1['en'], f2[lang], [lang])

    File.open("config/locales/#{name}.#{lang}.yml", 'w') { |f| YAML.dump(@data, f) }
end
