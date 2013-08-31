require "pulse_ffi/mainloop"

require "rspec/mocks"

include PulseFFI

def test_bindings
  bindings
end

class PulseTest
  attr_reader :bindings

  def initialize
    RSpec::Mocks::setup(self)
    @bindings = double
    @bindings.stub(:pa_mainloop_new).and_return(:loop_ptr)
    @bindings.stub(:pa_mainloop_get_api).and_return(:pa_api)
    @bindings.stub(:pa_context_new).and_return(:pa_context)
  end

  def main_loop
    Mainloop.new(:bindings => bindings)
  end

  def context
    main_loop.context("Test")
  end

end

