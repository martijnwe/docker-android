require 'jenkins_api_client'
require 'jenkins_api_client/urihelper'
require 'yaml'

include JenkinsApi::UriHelper

ymlEnv = ARGV[0]
ymlEnv="./environments.yml" if ymlEnv == nil

parsed = begin
  descriptor = YAML.load(File.open(ymlEnv))
rescue ArgumentError => e
  puts "Could not parse environment descriptor: #{e.message}"
end

@client = JenkinsApi::Client.new(
    :server_ip =>descriptor['jenkins']['host']
    )

@client.system.wait_for_ready

descriptor['jobs'].each do |jobdesc| 
    job = jobdesc['job']

    if @client.job.exists?(job['name'])
       @client.job.delete(job['name'])
    end


    params = {}
    params[:name] = job['name'] 
    params[:keep_dependencies] = true 
    params[:concurrent_build] = true 
    params[:scm_provider] = job['vcs_provider'] 
    params[:scm_url] = job['vcs_url'] 
    params[:shell_command] = job['buildcmd'] 
    
    if job['schedule']
        params[:scm_trigger] = job['schedule'] 
    end
   
    if job['children']
        params[:child_projects] = job['children'] 
    end 

    # Create job
    @client.job.create_freestyle(params)

    # Configure properties
    if job['properties'] 
        xml = @client.job.get_config(job['name'])
        n_xml = Nokogiri::XML(xml)
        p_xml = Nokogiri::XML::Builder.new(:encoding => "UTF-8") do |b_xml|
           b_xml.send("hudson.plugins.envfile.EnvFileBuildWrapper") {
               b_xml.filePath job['properties']
           }
        end
        envFileWrapperXml = Nokogiri::XML(p_xml.to_xml).xpath(
           "//hudson.plugins.envfile.EnvFileBuildWrapper"
        ).first
        n_xml.xpath("//buildWrappers").first.add_child(envFileWrapperXml)
        @client.post_config("/job/#{path_encode job['name']}/config.xml", n_xml.to_xml)
    end
end


