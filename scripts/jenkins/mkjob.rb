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


descriptor['jobs'].each {|k,job| 

    @client.job.create_freestyle(
      :name => job['name'],
      :keep_dependencies => true,
      :concurrent_build => true,
      :scm_provider => job['vcs_provider'],
      :scm_url => job['vcs_url'],
      :shell_command => job['buildcmd']
)

}
