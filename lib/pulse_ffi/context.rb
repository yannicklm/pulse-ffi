module PulseFFI
  class Context
    attr_reader :pa_context, :name

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
  end
end
