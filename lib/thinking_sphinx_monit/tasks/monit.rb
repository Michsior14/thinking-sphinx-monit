require 'thinking-sphinx'

namespace :ts_monit do

  desc 'Generates Thinking Sphinx monit-service'
  task :config, [:user, :sudo, :tmp_dir, :monit_conf_dir, :monit_bin, :service_name] => [:environment] do |_, args|
    @searchd = searchd
    @config_path = config.configuration_file
    @ts_pid_file = config.searchd.pid_file
    @user = args.user
    @service_name = args.service_name
    template_sphinx 'ts_monit.conf', "#{args.tmp_dir}/ts_monit.conf"
    sudo_if_needed args.sudo, "mv #{args.tmp_dir}/ts_monit.conf #{args.monit_conf_dir}"
    sudo_if_needed args.sudo, "#{args.monit_bin} reload"
  end

  def sudo_if_needed(sudo, command)
    if sudo
      system "sudo #{command}"
    else
      exec "#{command}"
    end
  end

  def config
    ThinkingSphinx::Configuration.instance
  end

  def searchd
    con = config.controller
    "#{con.bin_path}#{con.searchd_binary_name}"
  end

  def template_sphinx(from, to)
    [
        "lib/thinking_sphinx_monit/templates/#{from}.erb",
        "config/deploy/templates/#{from}.erb",
        File.expand_path("../../templates/#{from}.erb", __FILE__)
    ].each do |path|
      if File.file?(path)
        erb = File.read(path)
        File.write(to, StringIO.new(ERB.new(erb, nil, '-').result(binding)).read)
        break
      end
    end
  end

end