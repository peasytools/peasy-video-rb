# frozen_string_literal: true

require "open3"
require "json"
require "tempfile"

module PeasyVideo
  FORMATS = %w[mp4 webm mkv avi mov gif].freeze

  module_function

  def info(path)
    cmd = %W[ffprobe -v quiet -print_format json -show_format -show_streams #{path}]
    out, err, st = Open3.capture3(*cmd)
    raise Error, "ffprobe failed: #{err}" unless st.success?
    data = JSON.parse(out)
    fmt = data["format"] || {}
    vs = (data["streams"] || []).find { |s| s["codec_type"] == "video" } || {}
    {
      duration: fmt["duration"]&.to_f,
      width: vs["width"]&.to_i,
      height: vs["height"]&.to_i,
      fps: eval_fps(vs["r_frame_rate"]),
      codec: vs["codec_name"],
      format: fmt["format_name"],
      bitrate: fmt["bit_rate"]&.to_i,
      size: fmt["size"]&.to_i,
      has_audio: (data["streams"] || []).any? { |s| s["codec_type"] == "audio" },
    }
  end

  def trim(input, start: 0, duration: nil, end_time: nil, output: nil)
    output ||= input.to_s.sub(/(\.\w+)$/, "_trimmed\\1")
    args = ["ffmpeg", "-y", "-i", input.to_s, "-ss", start.to_s]
    args += ["-t", duration.to_s] if duration
    args += ["-to", end_time.to_s] if end_time
    args << output
    _o, err, st = Open3.capture3(*args)
    raise Error, "trim failed: #{err}" unless st.success?
    output
  end

  def resize(input, width:, height: nil, output: nil)
    output ||= input.to_s.sub(/(\.\w+)$/, "_resized\\1")
    h = height || -2
    _o, err, st = Open3.capture3("ffmpeg", "-y", "-i", input.to_s, "-vf", "scale=#{width}:#{h}", output)
    raise Error, "resize failed: #{err}" unless st.success?
    output
  end

  def thumbnail(input, time: 0, output: nil)
    output ||= input.to_s.sub(/\.\w+$/, "_thumb.png")
    _o, err, st = Open3.capture3("ffmpeg", "-y", "-i", input.to_s, "-ss", time.to_s, "-vframes", "1", output)
    raise Error, "thumbnail failed: #{err}" unless st.success?
    output
  end

  def video_to_gif(input, fps: 10, width: 480, output: nil)
    output ||= input.to_s.sub(/\.\w+$/, ".gif")
    filter = "fps=#{fps},scale=#{width}:-1:flags=lanczos"
    _o, err, st = Open3.capture3("ffmpeg", "-y", "-i", input.to_s, "-vf", filter, output)
    raise Error, "gif conversion failed: #{err}" unless st.success?
    output
  end

  def extract_audio(input, format: "mp3", output: nil)
    output ||= input.to_s.sub(/\.\w+$/, ".#{format}")
    _o, err, st = Open3.capture3("ffmpeg", "-y", "-i", input.to_s, "-vn", output)
    raise Error, "extract audio failed: #{err}" unless st.success?
    output
  end

  class Error < StandardError; end

  def eval_fps(rate_str)
    return nil unless rate_str
    num, den = rate_str.split("/").map(&:to_f)
    den && den > 0 ? (num / den).round(2) : num
  end
  private_class_method :eval_fps
end
