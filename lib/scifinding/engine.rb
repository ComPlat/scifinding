module Scifinding
  class Engine < ::Rails::Engine
    isolate_namespace Scifinding
    #config.browserify_rails.node_bin = (File.join("/home/pitrem/workspace5/chemotion_ELN","node_modules/.bin/").to_s)
    #config.browserify_rails.paths << lambda { |p| p.start_with?(Engine.root.join("app").to_s)}
    #config.browserify_rails.commandline_options = "-t babelify -t  aliasify  "

    config.to_prepare do
      Dir.glob(Engine.root + "app/serializers/**/*_serializer*.rb").each do |c|
        require_dependency(c)
      end
      require_dependency(File.join(Engine.root , "app/api/api.rb"))
    end

    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'scifinding_env.yml')
      YAML.load(File.read(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)
    end

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

  end
  
end
