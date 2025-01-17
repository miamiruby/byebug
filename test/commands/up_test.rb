require 'test_helper'

module Byebug
  #
  # Tests the +up+ command.
  #
  class UpTestCase < TestCase
    def program
      strip_line_numbers <<-EOP
         1:  module Byebug
         2:    #
         3:    # Toy class to test backtraces.
         4:    #
         5:    class #{example_class}
         6:      def initialize(letter)
         7:        @letter = encode(letter)
         8:      end
         9:
        10:      def encode(str)
        11:        integerize(str + 'x') + 5
        12:      end
        13:
        14:      def integerize(str)
        15:        byebug
        16:        str.ord
        17:      end
        18:    end
        19:
        20:    frame = #{example_class}.new('f')
        21:
        22:    frame
        23:  end
      EOP
    end

    def test_up_moves_up_in_the_callstack
      enter 'up'

      debug_code(program) { assert_equal 11, frame.line }
    end

    def test_up_moves_up_in_the_callstack_a_specific_number_of_frames
      enter 'up 2'

      debug_code(program) { assert_equal 7, frame.line }
    end

    def test_up_does_not_move_if_frame_number_to_too_high
      enter 'up 100'

      debug_code(program) { assert_equal 16, frame.line }
      check_error_includes "Can't navigate beyond the oldest frame"
    end

    def test_up_skips_c_frames
      enter 'up 2', 'frame'
      debug_code(program)

      check_output_includes(
        /--> #2  .*initialize\(letter#String\)\s* at .*#{example_path}:7/)
    end

    def test_up_plays_well_with_evaluation
      enter 'str', 'up', 'str', 'up'
      debug_code(program)

      check_output_includes 'fx', 'f'
    end
  end
end
