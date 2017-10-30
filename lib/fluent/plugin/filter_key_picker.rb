# coding: utf-8
require 'fluent/plugin/key_picker_support'

module Fluent
  class KeyPickerFilter < Filter
    include Fluent::KeyPickerSupport

    Fluent::Plugin.register_filter('key_picker', self)

    config_param :keys, :string, :default => nil

    def configure(conf)
      super

      unless keys && keys.length > 1
        raise ConfigError, "keys: You need to specify the keys you want to pick."
      end

      @keys = keys && keys.split(/\s*,\s*/)
    end

    def start
      super
    end

    def shutdown
      super
    end

    def filter(tag, time, record)
      pick_key(record, self)
    end
  end
end
