require_relative 'pulse_ffi/bindings'
require_relative 'pulse_ffi/mainloop'

module PulseFFI

  def self.mainloop(&run_callback)
    Mainloop.run(&run_callback)
  end
end
