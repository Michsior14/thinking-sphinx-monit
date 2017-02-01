module ThinkingSphinxMonit
  class MonitRailtie < Rails::Railtie
    rake_tasks do
      load File.expand_path('../tasks/monit.rb', __FILE__)
    end
  end
end
