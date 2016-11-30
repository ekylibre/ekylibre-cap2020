module Cap2020
  class Engine < ::Rails::Engine
    initializer :assets do |config|
      Rails.application.config.assets.precompile += %w( integrations/cap_trap.png integrations/cap_trap.svg )
    end
  end
end
