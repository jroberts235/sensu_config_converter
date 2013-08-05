#!/Users/jroberts/.rvm/rubies/ruby-1.9.3-p429/bin/ruby

require 'json'

def load_json( filename )
  JSON.parse( IO.read(filename) )
end

addons = {}
a = ['notification', 'refresh', 'occurrences'] # these are now called 'additionals' by sensu
data = load_json('config.json')
data['checks'].each do |block| 
  adds = "" # flush 
  addons = {} # flush 
  puts "sensu_check \"#{block[0].downcase}\" do" # standardize to all lower case names
  block[1].each do |k, v| 
    if a.include? k
      addons[k] = v
      next
    end 
    v = v.gsub(/checks/, 'status') if v == 'checks' # check is not a valid type anymore
    unless (v.is_a? Array or k == "interval") # interval is an int
      puts "  #{k} \"#{v}\""                  # no "'s for Arrays
    else 
      puts "  #{k} #{v}"
    end
  end
  addons.each do |k, v|
    unless k == "notification" # notification is a str and needs "'s
      adds += ":#{k} => #{v}"
    else
      adds += ":#{k} => \"#{v}\""
    end
    adds += ", " if addons.length > 1 # comma seperate the hash
  end
  puts "  additional(#{adds})" if addons.length > 0
  puts "end"
  puts
end
