require 'pulse_ffi/mainloop'
require 'pulse_ffi/context'

include PulseFFI

describe Context do
  specify "initialize calls pa_context_new" do
    bindings = double
    mainloop = double(:pa_api => :pa_api,
                      :bindings => bindings)
    bindings.should_receive(:pa_context_new).
      with(:pa_api, "the name").
      and_return(:pa_context)
    context = Context.new(mainloop, "the name")
  end

  specify "disconnects calls pa_context_disconnect" do
    context, bindings = test_context
    bindings.should_receive(:pa_context_disconnect).
      with(:pa_context)
    context.disconnect
  end

  it "can specify options to pa_context_connect" do
    context, bindings = test_context
    bindings.should_receive(:pa_context_connect).
      with(:pa_context, :server, :flags, :spawn_api)
    context.connect(:server => :server,
                    :flags => :flags,
                    :spawn_api => :spawn_api)
  end

  it "uses passes correct options to pa_context_connect by default" do
    context, bindings = test_context
    bindings.should_receive(:pa_context_connect).
      with(:pa_context, nil, :noflags, nil)
    context.connect
  end

  specify "#state delegates to pa_context_get_state" do
    context, bindings = test_context
    bindings.should_receive(:pa_context_get_state).
      with(:pa_context)
    context.state
  end


  def test_context
    bindings = double
    bindings.stub(:pa_mainloop_new).and_return(:loop_ptr)
    bindings.stub(:pa_mainloop_get_api).and_return(:pa_api)
    bindings.stub(:pa_context_new).and_return(:pa_context)
    main_loop = Mainloop.new(:bindings => bindings)
    res = main_loop.context("Test")
    return res, bindings
  end



end
