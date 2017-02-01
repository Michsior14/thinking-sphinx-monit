namespace :load do
  task :defaults do
    set :thinking_sphinx_monit_conf_dir, -> { "/etc/monit/conf.d/#{ts_monit_service_name}.conf" }
    set :thinking_sphinx_use_sudo, true
    set :thinking_sphinx_monit_bin, '/usr/bin/monit'
  end
end

namespace :thinking_sphinx_monit do
  desc 'Generates Thinking Sphinx monit-service'
  task :config do
    on roles(fetch(:thinking_sphinx_roles)) do |role|
      within current_path do
        with rails_env: fetch(:thinking_sphinx_rails_env) do
          execute :rake, "ts_monit:config[#{role.user},#{fetch(:thinking_sphinx_use_sudo)},#{fetch(:tmp_dir)},#{fetch(:thinking_sphinx_monit_conf_dir)},#{fetch(:thinking_sphinx_monit_bin)},#{ts_monit_service_name},#{fetch(:rails_env)}]"
        end
      end
    end
  end

  desc 'Monitor Thinking Sphinx monit-service'
  task :monitor do
    on roles(fetch(:thinking_sphinx_roles)) do
      begin
        sudo_if_needed "#{fetch(:thinking_sphinx_monit_bin)} monitor #{ts_monit_service_name}"
      rescue
        invoke 'thinking_sphinx:monit:config'
        sudo_if_needed "#{fetch(:thinking_sphinx_monit_bin)} monitor #{ts_monit_service_name}"
      end
    end
  end

  desc 'Unmonitor Thinking Sphinx monit-service'
  task :unmonitor do
    on roles(fetch(:thinking_sphinx_roles)) do
      begin
        sudo_if_needed "#{fetch(:thinking_sphinx_monit_bin)} unmonitor #{ts_monit_service_name}"
      rescue
        # no worries here (still no monitoring)
      end
    end
  end

  desc 'Start Thinking Sphinx monit-service'
  task :start do
    on roles(fetch(:thinking_sphinx_roles)) do
      sudo_if_needed "#{fetch(:thinking_sphinx_monit_bin)} start #{ts_monit_service_name}"
    end
  end

  desc 'Stop Thinking Sphinx monit-service'
  task :stop do
    on roles(fetch(:thinking_sphinx_roles)) do
      sudo_if_needed "#{fetch(:thinking_sphinx_monit_bin)}  stop #{ts_monit_service_name}"
    end
  end

  desc 'Restart Thinking Sphinx monit-service'
  task :restart do
    on roles(fetch(:thinking_sphinx_roles)) do
      sudo_if_needed "#{fetch(:thinking_sphinx_monit_bin)} restart #{ts_monit_service_name}"
    end
  end

  def ts_monit_service_name
    fetch(:ts_monit_service_name, "thinking_sphinx_#{fetch(:application)}_#{fetch(:stage)}")
  end

  def sudo_if_needed(command)
    if fetch(:thinking_sphinx_use_sudo)
      sudo command
    else
      execute command
    end
  end

  before 'thinking_sphinx:stop', 'thinking_sphinx_monit:unmonitor'
  after 'thinking_sphinx:start', 'thinking_sphinx_monit:monitor'
end