require 'test_helper'

module Byebug
  class ScriptInterfaceTest < TestCase
    def test_initialize_wires_up_dependencies
      with_new_file('show') do |path|
        interface = ScriptInterface.new(path)

        assert_instance_of File, interface.input
        assert_instance_of StringIO, interface.output
        assert_instance_of StringIO, interface.error
      end
    end

    def test_initialize_verbose_writes_to_stdout_and_stderr
      with_new_file('show') do |path|
        interface = ScriptInterface.new(path, true)

        assert_instance_of File, interface.input
        assert_equal STDOUT, interface.output
        assert_equal STDERR, interface.error
      end
    end

    def test_readline_reads_input_until_first_non_comment
      with_new_file("# Run the show command\nshow\n") do |path|
        interface = ScriptInterface.new(path)

        assert_equal 'show', interface.readline
      end
    end
  end
end
