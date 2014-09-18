# coding: utf-8

module Fluent
  class KeyPickerOutput < Output
    include Fluent::HandleTagNameMixin

    Fluent::Plugin.register_output('key_picker', self)

    config_param :keys, :string, :default => nil
    config_param :add_tag_and_reemit, :bool, :default => false

    def configure(conf)
      super

      if (
          !remove_tag_prefix &&
          !remove_tag_suffix &&
          !add_tag_prefix    &&
          !add_tag_suffix
      )
        raise ConfigError, "out_key_picker: At least one of remove_tag_prefix/remove_tag_suffix/add_tag_prefix/add_tag_suffix is required to be set."
      end

      unless keys && !keys.nil?
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

    def emit(tag, es, chain)
      es.each {|time,record|
        t = tag.dup
        filter_record(t, time, record)
        Engine.emit(t, time, record)
      }
      chain.next
    end

    def filter_record(tag, time, record)
      begin
        record.keep_if{|key, value| @keys.include?(key.to_s)}
      rescue ArgumentError => error
        $log.warn("out_key_picker: #{error.message}")
      end
      super(tag, time, record)
    end
  end
end
