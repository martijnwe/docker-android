require 'jenkins_api_client'
require 'yaml'


ymlCmd = ARGV[0]

parsed = begin
  descriptor = YAML.load(File.open(ymlCmd))
rescue ArgumentError => e
  puts "Could not parse YAML: #{e.message}"
end

puts descriptor.inspect

@client = JenkinsApi::Client.new(:server_ip => 'localhost',:username => 'jenkins', :password => 'jenkins')
# The following call will return all jobs matching 'Testjob'
puts @client.job.list_all


@client.job.create_freestyle(
  :name => "Werckmeister Assemble",
  :keep_dependencies => true,
  :concurrent_build => true,
  :scm_provider => "subversion",
  :scm_url => "svn:192.168.32.4/Tuner",
  :shell_command => "$WORKSPACE/gradlew assembleDebug"
)


