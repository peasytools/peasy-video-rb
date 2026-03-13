# frozen_string_literal: true

require "minitest/autorun"
require "peasy_video"

class TestPeasyVideo < Minitest::Test
  def test_version
    refute_nil PeasyVideo::VERSION
    assert_equal "0.1.1", PeasyVideo::VERSION
  end
end
