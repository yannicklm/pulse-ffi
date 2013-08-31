require 'spec_helper'

require 'pulse_ffi/source_info_list'


include PulseFFI

describe SourceInfoList do

  it "is initialized with a context" do
    pulse_test = PulseTest.new
    context = pulse_test.context
    source_list = SourceInfoList.new(context)
  end

  it "can loop through source info" do
    pulse_test = PulseTest.new
    sources = []
    pulse_test.source_info.each { |source|
      sources << source
    }
    expect(sources).to have(3).items
  end


end
