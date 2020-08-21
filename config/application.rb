require_relative 'boot'
require 'open-uri'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Venjob
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.gitignore.yml')
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(env_file)

      text_file = File.join(Rails.root, 'config', 'text_flash.yml')
      YAML.load(File.open(text_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists?(text_file)
    end
    # config.filter_parameter_logging << :oldpassword, :password
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
