require 'jenkins_api_client'
require 'yaml'

ymlEnv = ARGV[0]
ymlEnv="./default.yml" if ymlEnv == nil

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
@client.post_data("/descriptor/jenkins.install.UpgradeWizard/upgrade","", "application/xml;charset=UTF-8", )


@client.system.restart(true) 
@client.system.wait_for_ready

puts "upgraded plugins and restarted..."
