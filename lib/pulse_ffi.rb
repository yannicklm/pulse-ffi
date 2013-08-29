require_relative 'pulse_ffi/bindings'

module PulseFFI

  def self.mainloop(&run_callback)
    Mainloop.run(&run_callback)
  end
end
