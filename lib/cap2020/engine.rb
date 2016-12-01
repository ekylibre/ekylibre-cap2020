module Cap2020
  class Engine < ::Rails::Engine
    initializer :assets do |config|
      Rails.application.config.assets.precompile += %w( integrations/cap_trap.png integrations/cap_trap.svg )
    end

    initializer :i18n do |app|
      app.config.i18n.load_path += Dir[Cap2020::Engine.root.join('config', 'locales', '*.yml')]
    end
  end
end
