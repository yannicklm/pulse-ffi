require_relative "context"

module PulseFFI

  class Mainloop
    attr_reader :pointer, :bindings


    def self.run(options = {})
      loop = new(options)
      yield(loop)
      loop.run
    ensure
      loop.free
    end

    def initialize(options = {})
      @bindings = options.fetch(:bindings) {
        Object.new.extend(Bindings)
      }
      @pointer = @bindings.pa_mainloop_new
    end

    def run
      @bindings.pa_mainloop_run(@pointer, nil)
    end

    def free
      @bindings.pa_mainloop_free(@pointer)
    end

    def quit(rc)
      @bindings.pa_mainloop_quit(@pointer, rc)
    end

    def pa_api
      @bindings.pa_mainloop_get_api(@pointer)
    end

    def context(name)
      Context.new(self, name)
    end

  end

end
