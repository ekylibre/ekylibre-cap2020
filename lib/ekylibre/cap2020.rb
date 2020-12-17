# frozen_string_literal: true

require 'ekylibre-plugin_system'

require_relative 'cap2020/plugin/cap2020_plugin'
require_relative 'cap2020/version'

require_relative 'cap2020/engine' if defined?(::Rails)
