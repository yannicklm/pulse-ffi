module PulseFFI
  class SourceInfoList
    attr_reader :bindings, :context

    def initialize(context)
      @context = context
      @bindings = context.bindings
    end

  end
end

