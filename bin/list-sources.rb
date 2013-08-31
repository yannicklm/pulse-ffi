require_relative '../lib/pulse_ffi'

include PulseFFI::Bindings

PulseFFI.mainloop do |mainloop|
  context = mainloop.context("RubyTapas")
  pa_context = context.pa_context
  context.on_state_change do |context|
    if context.state == :ready
      print_audio_source = ->(pa_context, source_info_ptr, eol, userdata) do
        # End of list
        if eol == 1
          context.disconnect
          mainloop.quit(0)
          return
        end

        source_info = SourceInfo.new(source_info_ptr)
        puts "#{source_info[:index]} #{source_info[:description]}"
      end

      pa_context_get_source_info_list(pa_context, print_audio_source, nil)
    end
  end
  context.connect
end
