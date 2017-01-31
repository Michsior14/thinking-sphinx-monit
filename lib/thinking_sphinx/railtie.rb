module ThinkingSphinx
  class Monit < Rails::Railtie
    rake_tasks do
      load File.expand_path('../monit.rb', __FILE__)
    end
  end
end
