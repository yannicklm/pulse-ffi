require 'minitest/autorun'
require 'rake'

class SmokeTest < MiniTest::Unit::TestCase
  def test_list_sources
    output = `#{list_sources_commands}`
    refute_match /Sine source at 440 Hz/, output

    module_id =
      `pactl load-module module-sine-source source_name=TEST_SOURCE`.strip
    output = `#{list_sources_commands}`
    assert_match /Sine source /, output
  ensure
    `pactl unload-module #{module_id}` if module_id
  end

  def list_sources_commands
    script_path = File.expand_path('../../list-sources.rb', __FILE__)
    "#{FileUtils::RUBY} #{script_path}"
  end
end
