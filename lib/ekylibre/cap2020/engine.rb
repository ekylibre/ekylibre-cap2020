# frozen_string_literal: true

module Ekylibre
  module Cap2020
    class Engine < ::Rails::Engine
      extend Ekylibre::PluginSystem::PluginRegistration

      register_plugin(Ekylibre::Cap2020::Plugin::Cap2020Plugin)

      initializer :assets do |_config|
        Rails.application.config.assets.precompile += %w[integrations/cap_trap.png integrations/cap_trap.svg]
      end
      
      initializer :i18n do |app|
        app.config.i18n.load_path += Dir[Ekylibre::Cap2020::Engine.root.join('config', 'locales', '*.yml')]
      end
    end
  end
end
