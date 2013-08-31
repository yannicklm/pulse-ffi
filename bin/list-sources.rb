require_relative '../lib/pulse_ffi'

include PulseFFI::Bindings

PulseFFI.mainloop do |mainloop|
  context = mainloop.context("RubyTapas")
  pa_context = context.pa_context

  start_query_when_ready = ->(pa_context, userdata) do
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

  pa_context_set_state_callback(pa_context,
                                start_query_when_ready, nil)

  context.connect
end
