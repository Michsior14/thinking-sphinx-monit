module ThinkingSphinxMonit
  class TemplateGenerator < Rails::Generators::Base

    namespace 'thinking_sphinx_monit:template'
    desc 'Create local monitrc.erb, and erb files for monitored processes for customization'
    source_root File.expand_path('../../..thinking_sphinx_monit/templates', __FILE__)
    argument :templates_path, type: :string,
             default: 'config/deploy/templates',
             banner: 'path to templates'

    def copy_template
      copy_file 'ts_monit.conf.erb', "#{templates_path}/ts_monit.erb"
    end

  end
end
