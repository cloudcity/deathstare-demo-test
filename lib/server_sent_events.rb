require 'json'

module ServerSentEvents
  module CanConvertToSSE

    # Converts a Ruby object to the format required by Server Sent Events.
    # It'll call the object's .as_json to serialize
    # The options has can inject additional keys to the SSE
    # If the object has an :id key, that'll also be sent as extra key
    def to_sse(options={})
      object_hash = self.as_json
      options[:id] ||= object_hash[:id] if object_hash.has_key?(:id)
      str = options.reduce('') do |str, kvpair|
        str += "#{kvpair.first}: #{kvpair.second}\n"
      end
      str << "data: #{object_hash.to_json}\n\n"
    end
  end

  class SSEStream
    def initialize io
      @io = io
    end

    def write object, options = {}
      options.each do |k,v|
        @io.write "#{k}: #{v}\n"
      end
      @io.write "data: #{JSON.dump(object)}\n\n"
    end

    def close
      @io.close
    end
  end
end