# ThinkingSphinx::Monit

Monit integration with Thinking Sphinx and CapistranoV3

## Installation

Add this line to your application's Gemfile:

    gem 'thinking-sphinx-monit'

And then execute:

    $ bundle install

## Usage
Add to your capfile following line:
```ruby
# Capfile
require 'thinking_sphinx_monit/capistrano'
```
It's also needed to specify thinking sphinx hooks in your deploy.rb, for example like this:
```ruby
before 'deploy:updating', 'thinking_sphinx:stop'
after 'deploy:published', 'thinking_sphinx:start'
after 'thinking_sphinx:start', 'thinking_sphinx:index'
```

That's because monit is started and stopped before and after thinking_sphinx stop/start:
```ruby
before 'thinking_sphinx:stop', 'thinking_sphinx_monit:unmonitor'
after 'thinking_sphinx:start', 'thinking_sphinx_monit:monitor'
```

Of course you can do everything manually, but remember to do ```cap <stage> deploy``` before any following tasks (just once per stage):
```ruby
cap thinking_sphinx_monit:config     # Generates Thinking Sphinx monit-service
cap thinking_sphinx_monit:monitor    # Monitor Thinking Sphinx monit-service
cap thinking_sphinx_monit:restart    # Restart Thinking Sphinx monit-service
cap thinking_sphinx_monit:start      # Start Thinking Sphinx monit-service
cap thinking_sphinx_monit:stop       # Stop Thinking Sphinx monit-service
cap thinking_sphinx_monit:unmonitor  # Unmonitor Thinking Sphinx monit-service
```

## Defaults
```ruby
set :thinking_sphinx_monit_conf_dir, -> { "/etc/monit/conf.d/#{ts_monit_service_name}.conf" }
set :thinking_sphinx_use_sudo, true
set :thinking_sphinx_monit_bin, '/usr/bin/monit'
```

## Dependencies
- 'capistrano', '~> 3.0', '>= 3.0.0'
- 'thinking-sphinx', '~> 3.3.0'

## Customizing Monit template

If you need change config for Monit, you can:

```
bundle exec rails generate thinking_sphinx_monit:template
```
and edit template in your config/deploy/templates folder.

## Contributing
Feel free to contribute.