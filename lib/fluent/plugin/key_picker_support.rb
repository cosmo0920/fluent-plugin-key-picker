module Fluent
  module KeyPickerSupport
    def pick_key(record, plugin)
      begin
        return record.keep_if{|key, value| @keys.include?(key.to_s)}
      rescue ArgumentError => error
        plugin.log.warn("out_key_picker: #{error.message}")
      end
    end
  end
end
