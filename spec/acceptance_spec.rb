require 'rake' # for FileUtils::RUBY

describe "list-sources script" do
  before(:each) {
    @module_id = nil
  }

  after(:each) {
    `pactl unload-module #{@module_id}`
  }

  it "can list the pulse sources"  do
    output = `#{list_sources_command}`
    expect(output).not_to match /Sine source at 440 Hz/
    @module_id = `pactl load-module module-sine-source source_name=TEST_SOURCE`.strip
    output = `#{list_sources_command}`
    expect(output).to match /Sine source at 440 Hz/
  end

  def list_sources_command
    script_path = File.expand_path('../../bin/list-sources.rb', __FILE__)
    "#{FileUtils::RUBY} #{script_path}"
  end

end
