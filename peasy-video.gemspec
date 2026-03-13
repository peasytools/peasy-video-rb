# frozen_string_literal: true

require_relative "lib/peasy_video/version"

Gem::Specification.new do |s|
  s.name        = "peasy-video"
  s.version     = PeasyVideo::VERSION
  s.summary     = "Video processing — trim, resize, thumbnails, GIF conversion"
  s.description = "Video processing library for Ruby — trim, resize, rotate, extract audio, generate thumbnails, convert to GIF. FFmpeg-powered with a clean Ruby API."
  s.authors     = ["PeasyTools"]
  s.email       = ["hello@peasytools.com"]
  s.homepage    = "https://peasyvideo.com"
  s.license     = "MIT"
  s.required_ruby_version = ">= 3.0"

  s.files = Dir["lib/**/*.rb"]

  s.metadata = {
    "homepage_uri"      => "https://peasyvideo.com",
    "source_code_uri"   => "https://github.com/peasytools/peasy-video-rb",
    "changelog_uri"     => "https://github.com/peasytools/peasy-video-rb/blob/main/CHANGELOG.md",
    "documentation_uri" => "https://peasyvideo.com",
    "bug_tracker_uri"   => "https://github.com/peasytools/peasy-video-rb/issues",
  }
end
