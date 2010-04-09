require 'commands/pick'

module Commands
  class Feature < Pick

    def type
      "feature"
    end
    
    def plural_type
      "features"
    end
    
    def branch_suffix
      "feature"
    end

    private
      def story
        # Try your own story first
        @story ||= project.stories.find(:conditions => { 
          :story_type => type, :current_state => :unstarted, :owner => options[:full_name]
        }, :limit => 1).first

        # try anything not started
        @story ||= project.stories.find(:conditions => { :story_type => type, :current_state => :unstarted }, :limit => 1).first
      end
  end
end