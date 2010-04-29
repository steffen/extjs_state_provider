module ExtJs
  class StateProvider
    def self.decode_value(value)
      return if value.blank? || value.nil?
      value = CGI::unescape(value)
      if value =~ /^(a|n|d|b|s|o)\:(.*)$/
        type = $1
        v = $2
        case type
        when "n"
          return Float(v)
        when "b"
          return (v == "1")
        when "a"
          all = []
          values = v.split('^')
          values.each do |v|
            all << decode_value(v)
          end
          return all
        when "o"
          all = {}
          values = v.split('^')
          values.each do |v|
            pair = v.split('=')
            all[pair[0]] = decode_value(pair[1])
          end
          return all
        else
          return v
        end
      end
    end
    
    def self.columns(data, groups = {})
      return nil unless data
      data = decode_value(data)
      
      # Don't include numberer or hidden columns
      data["columns"].reject! { |v| v["id"] == "numberer" || v["hidden"] }
      columns = data["columns"].map! { |v| v["id"].to_sym }
      
      if !groups.empty?
        columns.each_index do |i|
          if members = groups[columns[i]]
            columns[i] = members
          end
        end
      end
      columns.flatten
    end
  end
end