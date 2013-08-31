module PulseFFI
  class Context
    attr_reader :bindings, :pa_context, :name

    def initialize(pulse_loop, name)
      @name = name
      @bindings = pulse_loop.bindings
      @pa_context = @bindings.pa_context_new(pulse_loop.pa_api, name)
      @state = nil
    end

    def connect(options = {})
      server = options[:server]
      flags = options.fetch(:flags) { :noflags }
      spawn_api = options[:spawn_api]
      @bindings.pa_context_connect(@pa_context, server, flags, spawn_api)
    end

    def disconnect
      @bindings.pa_context_disconnect(@pa_context)
    end

    def state
      @bindings.pa_context_get_state(@pa_context)
    end

    def on_state_change(&callback)
      low_level_callback = Proc.new { |pa_context, data|
        callback.call(self, data)
      }
      @bindings.pa_context_set_state_callback(@pa_context,
                                              low_level_callback, nil)
    end

    def set_state_callback(callback, data=nil)
      @bindings.pa_context_set_state_callback(@pa_context, callback, data)
    end

    def source_info
      SourceInfoList.new(self)
    end
  end

end
