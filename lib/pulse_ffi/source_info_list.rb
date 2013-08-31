module PulseFFI
  class SourceInfoList
    include Enumerable

    attr_reader :bindings, :context

    def initialize(context)
      @pulse_loop = context.pulse_loop
      @context = context
      @bindings = context.bindings
    end

    def each(&block)
      callback = ->(pa_context, source_info_ptr, eol, userdata) do
        # End of list
        if eol == 1
          @context.disconnect
          @pulse_loop.quit(0)
          return
        end
        source_info = SourceInfo.new(source_info_ptr)
        block.call source_info
      end
      @bindings.pa_context_get_source_info_list(
        @context.pa_context,
        callback,
        nil)

    end
  end
end

