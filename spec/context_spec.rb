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

  specify "set_state_callbacks delegates to pa_context_set_state_callback" do
    context, bindings = test_context
    my_func = Proc.new {}
    bindings.should_receive(:pa_context_set_state_callback).
      with(:pa_context, my_func, :data)
    context.set_state_callback(my_func, :data)
  end

  specify "on_state_change with no data" do
    context, bindings = test_context

    bindings.should_receive(:pa_context_set_state_callback) do |context, callback|
      expect(context).to eq(:pa_context)
      callback.call(context) # this should call the block passed to on_state_change
    end

    probe = double
    probe.should_receive(:ping)

    context.on_state_change { |context|
      probe.ping
      expect(context.pa_context).to eq(:pa_context)
    }
  end

  specify "on_state_change with some user data" do
    context, bindings = test_context

    bindings.should_receive(:pa_context_set_state_callback) do |context, callback|
      expect(context).to eq(:pa_context)
      callback.call(context, 42)
    end

    probe = double
    probe.should_receive(:ping).with(42)

    context.on_state_change { |context, answer|
      probe.ping(answer)
      expect(context.pa_context).to eq(:pa_context)
    }
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
