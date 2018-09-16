require "./progress_tracker/stage"

module Crystal
  class ProgressTracker
    property? stats = false
    property? progress = false

    getter current_stage : Stage = Stage.new("", false)

    def stage(name)
      @current_stage = Stage.new(name, stats?)

      current_stage.start
      retval = yield
      current_stage.finish

      retval
    end

    def clear
      return unless progress?
      print " " * (Stage::STAGE_PADDING + 5)
      print "\r"
    end

    def increment_stage_progress
      current_stage.stage_progress += 1
      print_progress
    end

    def stage_progress_total=(stage_progress_total : Int32)
      current_stage.stage_progress_total = stage_progress_total
      print_progress
    end

    private def print_progress
      return unless progress?

      print current_stage.progress
    end
  end
end
