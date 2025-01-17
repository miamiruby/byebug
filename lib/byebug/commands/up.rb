require 'pathname'
require 'byebug/command'
require 'byebug/helpers/frame'
require 'byebug/helpers/parse'

module Byebug
  #
  # Move the current frame up in the backtrace.
  #
  class UpCommand < Command
    include Helpers::FrameHelper
    include Helpers::ParseHelper

    self.allow_in_post_mortem = true

    def self.regexp
      /^\s* u(?:p)? (?:\s+(\S+))? \s*$/x
    end

    def self.description
      <<-EOD
        up[ count]

        #{short_description}

        Use the "bt" command to find out where you want to go.
      EOD
    end

    def self.short_description
      'Moves to a higher frame in the stack trace'
    end

    def execute
      pos, err = parse_steps(@match[1], 'Up')
      return errmsg(err) unless pos

      adjust_frame(pos, false)

      ListCommand.new(processor).execute if Setting[:autolist]
    end
  end
end
