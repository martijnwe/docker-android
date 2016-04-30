require 'jenkins_api_client'

@client = JenkinsApi::Client.new(:server_ip => 'localhost',:username => 'jenkins', :password => 'jenkins')
# The following call will return all jobs matching 'Testjob'
puts @client.job.list_all


