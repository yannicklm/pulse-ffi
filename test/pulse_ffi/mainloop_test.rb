require 'minitest/autorun'
require 'pulse_ffi/mainloop'
require 'rspec/mocks'


module PulseFFI
  class MainloopTest < MiniTest::Unit::TestCase
    def setup
      RSpec::Mocks.setup(self)
    end

    def teardown
      RSpec::Mocks.verify
    ensure
      RSpec::Mocks.teardown
    end

    def test_class_run_creates_yields_runs_and_frees_mainloop
      loop = double
      Mainloop.stub("new", loop) do
        probe = double
        probe.should_receive(:ping).ordered
        loop.should_receive(:run).ordered
        loop.should_receive(:free).ordered
        Mainloop.run do
          probe.ping
        end
      end
    end

    def test_initialize_creates_mainloop
      api = double(pa_mainloop_new: :mainloop_ptr)

      loop = Mainloop.new(api: api)
      assert_equal :mainloop_ptr, loop.pointer
    end

    def test_run_starts_mainloop
      api = double(pa_mainloop_new: mainloop_ptr = double)
      api.should_receive(:pa_mainloop_run).with(mainloop_ptr, nil)
      loop = Mainloop.new(api: api)
      loop.run
    end

    def test_free_frees_mainloop
      api = double(pa_mainloop_new: mainloop_ptr = double)
      api.should_receive(:pa_mainloop_free).with(mainloop_ptr)
      loop = Mainloop.new(api: api)
      loop.free
    end

  end

end
