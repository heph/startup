module Extensions
  module Templates
    def format_upstart(key)
      value = instance_variable_get("@#{key.to_s}")
      key = key.to_s.gsub(/_/,' ')

      case value
      when TrueClass # print only 'key'
        key
      when Array # prefix multiple lines with 'key'
        value.map{ |v| "#{key} #{v}" }.join("\n")
      when String, Fixnum, Integer
        "#{key} #{value}\n"
      when Hash # prefix multiple lines with 'key', format 'value' as k=v (quote strings)
        value.map do |k,v|
          v = "\"#{v}\"" if v.is_a?(String)
          "#{key} #{k}=#{v}\n"
        end
      end
    end
  end
end




