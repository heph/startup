module Extensions
  module Templates
    def format_upstart(key)
      value = instance_variable_get("@#{key.to_s}")
      key = key.to_s.gsub(/_/,' ')

      case value
      when TrueClass # print only 'key'
        "#{key}\n"
      when Array # multiple values with the same 'key' e.g. 'export var1', 'export var2'
        value.map{ |v| "#{key} #{v}" }.join("\n")
      when String, Fixnum, Integer # print key followed by value
        "#{key} #{value}\n"
      when Hash # multiple values with the same 'key', format 'value' as k=v (quote strings) e.g. 'env FOO="BAR"', 'env BAR=42'
        value.map do |k,v|
          v = "\"#{v}\"" if v.is_a?(String)
          "#{key} #{k}=#{v}"
        end.join("\n")
      end
    end
  end
end
