require 'optparse'

module Commands
  class Base

    attr_accessor :input, :output, :options
  
    def initialize(input=STDIN, output=STDOUT, *args)
      @input = input
      @output = output
      @options = {}
      
      parse_gitconfig
      parse_argv(*args)
    end
  
    def put(string, newline=true)
      @output.print newline ? string + "\n" : string
    end

    def sys(cmd)
      put cmd if options[:verbose]
      system cmd
    end

    def get(cmd)
      put cmd if options[:verbose]
      `#{cmd}`
    end

  private

    def parse_gitconfig
      token = get("git config --get pivotal.api-token").strip
      id    = get("git config --get pivotal.project-id").strip
      name  = get("git config --get pivotal.full-name").strip

      options[:api_token] = token if token
      options[:project_id] = id if id
      options[:full_name] = name if name
    end

    def parse_argv(*args)
      OptionParser.new do |opts|
        opts.banner = "Usage: git pick [options]"
        opts.on("-k", "--api-key=", "Pivotal Tracker API key") { |k| options[:api_token] = k }
        opts.on("-p", "--project-id=", "Pivotal Trakcer project id") { |p| options[:project_id] = p }
        opts.on("-n", "--full-name=", "Pivotal Trakcer full name") { |n| options[:full_name] = n }
        opts.on("-q", "--quiet", "Quiet, no-interaction mode") { |q| options[:quiet] = q }
        opts.on("-v", "--[no-]verbose", "Run verbosely") { |v| options[:verbose] = v }
        opts.on_tail("-h", "--help", "This usage guide") { put opts; exit 0 }
      end.parse!(args)
    end

  end
end