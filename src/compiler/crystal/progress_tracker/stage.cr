module Crystal
  class Stage
    STAGE_PADDING = 34

    getter name : String
    getter? stats : Bool
    getter! start_time : Time::Span
    getter! end_time : Time::Span
    property stage_progress : Int32 = 0
    property stage_progress_total : Int32 | Nil

    @memory_usage : Float64 | Nil

    def initialize(@name, @stats)
    end

    def start
      print("#{justified_name}\r") if stats?
      @start_time = Time.monotonic
    end

    def finish
      @end_time = Time.monotonic

      time_taken = end_time - start_time
      memory_usage_str = " (%7.2fMB)" % {memory_usage}
      puts "#{justified_name} #{time_taken}#{memory_usage_str}" if stats?
    end

    def progress : String
      "[#{stage_progress}/#{stage_progress_total}] #{justified_name}\r"
    end

    private def justified_name : String
      "#{name}:".ljust(STAGE_PADDING)
    end

    private def memory_usage : Float64
      @memory_usage ||= GC.stats.heap_size / 1024.0 / 1024.0
    end
  end
end
