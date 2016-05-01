require 'jenkins_api_client'
require 'yaml'

ymlEnv = ARGV[0]
ymlEnv="./environments.yml" if ymlEnv == nil

parsed = begin
  descriptor = YAML.load(File.open(ymlEnv))
rescue ArgumentError => e
  puts "Could not parse environment descriptor: #{e.message}"
end

puts descriptor['jenkins']['host'] 

@client = JenkinsApi::Client.new(
    :server_ip =>descriptor['jenkins']['host']
    )

@client.system.wait_for_ready

restartRequired = false;
puts descriptor.inspect
descriptor['plugins'].each {|k,v| 
    k.each {|p,plugin| 
      @client.plugin.install plugin
      restartRequired = @client.plugin.restart_required?
    }
}
@client.system.restart(true) if restartRequired

