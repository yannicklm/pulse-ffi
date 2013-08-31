require_relative '../lib/pulse_ffi'

include PulseFFI::Bindings

PulseFFI.mainloop do |mainloop|
  context = mainloop.context("RubyTapas")
  pa_context = context.pa_context
  context.on_state_change do |context|
    begin
      if context.state == :ready
        source_info = context.source_info
        source_info.each do |source_info|
          puts "#{source_info[:index]} #{source_info[:description]}"
        end
      end
    rescue Exception => e
      p e
      print e.backtrace.join("\n")
      context.disconnect
      mainloop.quit
    end
  end
  context.connect
end
