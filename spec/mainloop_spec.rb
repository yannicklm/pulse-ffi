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
    api = double(:pa_mainloop_new => :mainloop_ptr)
    loop = Mainloop.new(api: api)
    expect(loop.pointer).to eq(:mainloop_ptr)
  end

  specify "#run starts mainloop" do
    api = double(pa_mainloop_new: mainloop_ptr = double)
    api.should_receive(:pa_mainloop_run).with(mainloop_ptr, nil)
    loop = Mainloop.new(api: api)
    loop.run
  end

  specify "#free frees mainloop" do
    api = double(pa_mainloop_new: mainloop_ptr = double)
    api.should_receive(:pa_mainloop_free).with(mainloop_ptr)
    loop = Mainloop.new(api: api)
    loop.free
  end

  specify "get api" do
    api = double(:pa_mainloop_new => :mainloop_ptr)
    api.should_receive(:pa_mainloop_get_api).
      with(:mainloop_ptr).
      and_return(:pulse_api)
    loop = Mainloop.new(api: api)
    expect(loop.api).to eq(:pulse_api)
  end

end
