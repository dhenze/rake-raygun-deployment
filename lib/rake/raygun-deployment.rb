require 'rake'
require 'rake/tasklib'
require 'net/http'
require 'yaml'
require 'json'

class Rake::RaygunDeployment < Rake::TaskLib

    def initialize(name=:raygun_deployment, &block)
        @releaseFilePath = nil
        @apiUri = nil
        @apiKey = nil
        @authToken = nil
        @use_ssl = true
        @use_git = true

        @config = block
        desc "Sends the latest deployment information to Raygun" unless Rake.application.last_comment
        task name do
            invoke
        end
    end

    def releasePath(path)
        @releaseFilePath = path;
    end

    def use_git(git)
        @use_git = git
    end

    def use_ssl(ssl)
        @use_ssl = ssl
    end

    def authToken(token)
        @authToken = token
    end

    def apiKey(key)
        @apiKey = key;
    end

    def apiUri(uri)
        @apiUri = uri;
    end

    def get_git_hash
        if @use_git && system('git rev-parse --verify HEAD')== true
            return `git rev-parse --verify HEAD`
        elsif @use_git
            puts 'could not get git commit info. Set `use_git false` to disable this message'
        end

        ""
    end

    def get_deployment
        raise "Need to set an authToken" if @authToken == nil
        raise "Need to set an apiKey" if @apiKey == nil

        @releaseFilePath ||= 'RELEASE'
        @apiUri ||= 'https://app.raygun.io'

        yaml = YAML::load_file(@releaseFilePath)

        if yaml == false
            raise "Invalid release file found at " + @releaseFilePath
        end

        return {
            'apiKey' => @apiKey,
            'version' => yaml['version'],
            'ownerName' => yaml['ownerName'],
            'emailAddress' => yaml['emailAddress'],
            'comment' => yaml['notes'],
            'scmIdentifier' => get_git_hash,
            'createdAt' => yaml['createdAt']
        }
    end

    def invoke
        instance_eval(&@config) unless @config == nil
        deployment = get_deployment
        send_deployment(deployment, URI.parse(@apiUri))
    end

    def send_deployment(deployment, uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = @use_ssl
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Post.new("/deployments?authToken=#{@authToken}")
        request.add_field('Content-Type', 'application/json')
        request.body = deployment.to_json
        res = http.request(request)
        case res
        when Net::HTTPSuccess
          # OK
            puts "Sent deployment to Raygun"
        when Net::HTTPRedirection
            puts "Authentication error - check your authToken and apiKey"
            puts res.value
        else
            raise "Error sending deployment to Raygun: " + res.value
        end
    end

end