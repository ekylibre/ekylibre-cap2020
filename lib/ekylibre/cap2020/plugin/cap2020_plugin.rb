# frozen_string_literal: true

using Corindon::DependencyInjection::Injectable

module Ekylibre
  module Cap2020
    module Plugin
      class Cap2020Plugin < Ekylibre::PluginSystem::Plugin
        injectable do
          tag 'ekylibre.system.plugin'
        end

        # @param [Ekylibre::PluginSystem::Container] container
        def boot(container) end

        def version
          Cap2020::VERSION
        end
      end
    end
  end
end
