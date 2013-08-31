require 'pulse_ffi/mainloop'

include PulseFFI

describe Mainloop do
  specify "self.run creates, yields, run and frees the main loop" do
    loop = double
    Mainloop.stub(:new => loop)
    probe = double
    probe.should_receive(:ping).with(loop).ordered
    loop.should_receive(:run).ordered
    loop.should_receive(:free).ordered
    Mainloop.run do |mainloop|
      probe.ping(mainloop)
    end
  end

  specify "self.run ensures mainloop freed" do
    loop = double.as_null_object
    Mainloop.stub(:new => loop)
    loop.should_receive(:free)
    begin
      Mainloop.run do
        raise Exception, "Oh no!"
      end
    rescue Exception
    end
  end

  specify "#initialize creates mainloop" do
    bindings = double(:pa_mainloop_new => :mainloop_ptr)
    loop = Mainloop.new(bindings: bindings)
    expect(loop.pointer).to eq(:mainloop_ptr)
  end

  specify "#run starts mainloop" do
    bindings = double(pa_mainloop_new: mainloop_ptr = double)
    bindings.should_receive(:pa_mainloop_run).with(mainloop_ptr, nil)
    loop = Mainloop.new(bindings: bindings)
    loop.run
  end

  specify "#free frees mainloop" do
    bindings = double(pa_mainloop_new: mainloop_ptr = double)
    bindings.should_receive(:pa_mainloop_free).with(mainloop_ptr)
    loop = Mainloop.new(bindings: bindings)
    loop.free
  end

  specify "#quit quits mainloop" do
    bindings = double(pa_mainloop_new: mainloop_ptr = double)
    bindings.should_receive(:pa_mainloop_quit).with(mainloop_ptr, 0)
    loop = Mainloop.new(bindings: bindings)
    loop.quit(0)
  end

  specify "get api" do
    bindings = double(:pa_mainloop_new => :mainloop_ptr)
    bindings.should_receive(:pa_mainloop_get_api).
      with(:mainloop_ptr).
      and_return(:pulse_api)
    loop = Mainloop.new(bindings: bindings)
    expect(loop.pa_api).to eq(:pulse_api)
  end

  specify "get context" do
    bindings = double(:pa_mainloop_new => :mainloop_ptr)
    bindings.should_receive(:pa_mainloop_get_api).
      with(:mainloop_ptr).
      and_return(:pulse_api)
    bindings.should_receive(:pa_context_new).
      with(:pulse_api, "the context").
      and_return(:context)

    loop = Mainloop.new(bindings: bindings)
    context = loop.context("the context")
    expect(context.pa_context).to eq(:context)
    expect(context.name).to eq("the context")

  end




end
