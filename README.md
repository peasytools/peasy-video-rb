# peasy-video

[![Gem Version](https://badge.fury.io/rb/peasy-video.svg)](https://rubygems.org/gems/peasy-video)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Ruby client for the [PeasyVideo](https://peasyvideo.com) API — calculate resolution, estimate bitrate, and analyze frame rates for video files. Zero dependencies beyond Ruby stdlib (Net::HTTP, JSON, URI).

Built from [PeasyVideo](https://peasyvideo.com), a comprehensive video processing toolkit offering free online tools for trimming, resizing, generating thumbnails, and creating GIFs from video files. The site includes in-depth guides on video codec selection, compression strategies for web delivery, and a glossary covering concepts from H.264 encoding and frame rates to container formats and color grading.

> **Try the interactive tools at [peasyvideo.com](https://peasyvideo.com)** — [Video Resolution Calculator](https://peasyvideo.com/video/video-resolution/), [Video Bitrate Calculator](https://peasyvideo.com/video/video-bitrate/), [Video Framerate Converter](https://peasyvideo.com/video/video-framerate/), and more.

<p align="center">
  <img src="demo.gif" alt="peasy-video demo — video resolution calculation and codec analysis tools in Ruby terminal" width="800">
</p>

## Table of Contents

- [Install](#install)
- [Quick Start](#quick-start)
- [What You Can Do](#what-you-can-do)
  - [Video Analysis Tools](#video-analysis-tools)
  - [Browse Reference Content](#browse-reference-content)
  - [Search and Discovery](#search-and-discovery)
- [API Client](#api-client)
  - [Available Methods](#available-methods)
- [Learn More About Video Tools](#learn-more-about-video-tools)
- [Also Available](#also-available)
- [Peasy Developer Tools](#peasy-developer-tools)
- [License](#license)

## Install

```bash
gem install peasy-video
```

Or add to your Gemfile:

```ruby
gem "peasy-video"
```

## Quick Start

```ruby
require "peasy_video"

client = PeasyVideo::Client.new

# List available video tools
tools = client.list_tools
tools["results"].each do |tool|
  puts "#{tool["name"]}: #{tool["description"]}"
end
```

## What You Can Do

### Video Analysis Tools

Digital video combines spatial resolution (the number of pixels in each frame) with temporal resolution (the number of frames displayed per second) to create the illusion of motion. A 1080p video at 30 fps produces 30 full 1920x1080 frames every second — over 62 million pixels per second of raw data. Codecs like H.264 (AVC) and H.265 (HEVC) use inter-frame prediction, motion compensation, and transform coding to compress this data by 100-1000x, while newer codecs like AV1 push efficiency even further at the cost of encoding time. PeasyVideo provides calculators and analysis tools for understanding these encoding parameters.

| Tool | Slug | Description |
|------|------|-------------|
| Resolution Calculator | `video-resolution` | Calculate pixel counts, aspect ratios, and display dimensions |
| Bitrate Calculator | `video-bitrate` | Estimate file sizes for different bitrate and duration combinations |
| Framerate Converter | `video-framerate` | Analyze frame rate conversions and motion smoothness trade-offs |

Common resolutions follow a progression from SD (480p, 640x480) through HD (720p, 1280x720) and Full HD (1080p, 1920x1080) to 4K UHD (2160p, 3840x2160) and beyond. Each step roughly quadruples the pixel count, dramatically increasing both visual clarity and storage requirements. At standard bitrates, a 1-minute 1080p H.264 video at 8 Mbps produces approximately 60 MB of data, while the same clip at 4K resolution typically requires 20-35 Mbps for acceptable quality.

```ruby
require "peasy_video"

client = PeasyVideo::Client.new

# Get the resolution calculator for pixel and aspect ratio analysis
tool = client.get_tool("video-resolution")
puts "Tool: #{tool["name"]}"              # Video resolution calculator name
puts "Description: #{tool["description"]}" # How resolution calculation works

# List all available video tools with pagination
tools = client.list_tools(page: 1, limit: 20)
puts "Total video tools available: #{tools["count"]}"
```

Learn more: [Video Resolution Calculator](https://peasyvideo.com/video/video-resolution/) · [Video Codecs Explained](https://peasyvideo.com/guides/video-codecs-explained/) · [Video Compression for Web Delivery](https://peasyvideo.com/guides/video-compression-web-delivery/)

### Browse Reference Content

PeasyVideo includes a comprehensive glossary of video engineering terminology and practical guides for common workflows. The glossary covers foundational concepts like H.264 (the most widely deployed video codec, used in everything from Blu-ray discs to web streaming), frame rate (the number of individual frames displayed per second, typically 24 fps for cinema, 30 fps for broadcast TV, and 60 fps for gaming), container formats (MP4 and WebM wrap encoded video and audio streams into a single file), and color grading (the process of altering the color and tone of footage for creative or corrective purposes).

| Term | Description |
|------|-------------|
| [AV1](https://peasyvideo.com/glossary/av1/) | AOMedia Video 1 — royalty-free codec with 30% better compression than H.265 |
| [Frame Rate](https://peasyvideo.com/glossary/frame-rate/) | Frames per second — 24 fps (cinema), 30 fps (broadcast), 60 fps (gaming) |
| [Color Grading](https://peasyvideo.com/glossary/color-grading/) | Creative color adjustment for tone, mood, and visual consistency |

The distinction between codecs and containers is essential for video engineering. A codec (H.264, H.265, VP9, AV1) compresses and decompresses the video data itself, while a container format (MP4, WebM, MKV, MOV) packages the compressed video stream together with audio tracks, subtitles, and metadata into a single file. The same H.264-encoded video can be wrapped in an MP4 container for broad device compatibility or in an MKV container for advanced features like multiple audio tracks and chapter markers.

```ruby
require "peasy_video"

client = PeasyVideo::Client.new

# Browse the video glossary for codec and encoding terminology
glossary = client.list_glossary(search: "codec")
glossary["results"].each do |term|
  puts "#{term["term"]}: #{term["definition"]}"
end

# Read a guide explaining video codec selection and trade-offs
guide = client.get_guide("video-codecs-explained")
puts "Guide: #{guide["title"]} (Level: #{guide["audience_level"]})"
```

Learn more: [Video Glossary](https://peasyvideo.com/glossary/) · [Video Codecs Explained](https://peasyvideo.com/guides/video-codecs-explained/) · [Video Compression for Web Delivery](https://peasyvideo.com/guides/video-compression-web-delivery/)

### Search and Discovery

The API supports full-text search across all content types — tools, glossary terms, guides, use cases, and format documentation. Search results are grouped by content type, making it easy to find the right tool or reference for any video workflow. Format conversion data covers the full matrix of source-to-target transformations, including codec compatibility constraints — for example, WebM containers only support VP8, VP9, and AV1 video codecs, while MP4 supports H.264, H.265, and AV1 among others.

```ruby
require "peasy_video"

client = PeasyVideo::Client.new

# Search across all video content — tools, glossary, guides, and formats
results = client.search("convert mp4")
puts "Found #{results["results"]["tools"].length} tools"
puts "Found #{results["results"]["glossary"].length} glossary terms"
puts "Found #{results["results"]["guides"].length} guides"

# Discover format conversion paths — what can WebM convert to?
conversions = client.list_conversions(source: "webm")
conversions["results"].each do |c|
  puts "#{c["source_format"]} -> #{c["target_format"]}"
end

# Get detailed information about a specific video format
format = client.get_format("mp4")
puts "#{format["name"]} (#{format["extension"]}): #{format["mime_type"]}"
```

| Format | Extension | Typical Codecs | Primary Use |
|--------|-----------|---------------|-------------|
| [MP4](https://peasyvideo.com/formats/mp4/) | `.mp4` | H.264, H.265, AV1 | Universal playback, streaming |
| [WebM](https://peasyvideo.com/formats/webm/) | `.webm` | VP8, VP9, AV1 | Web-optimized, open-source |

Learn more: [REST API Docs](https://peasyvideo.com/developers/) · [All Video Tools](https://peasyvideo.com/) · [All Formats](https://peasyvideo.com/formats/)

## API Client

The client wraps the [PeasyVideo REST API](https://peasyvideo.com/developers/) using only Ruby standard library — no external dependencies.

```ruby
require "peasy_video"

client = PeasyVideo::Client.new
# Or with a custom base URL:
# client = PeasyVideo::Client.new(base_url: "https://custom.example.com")

# List tools with pagination and filters
tools = client.list_tools(page: 1, limit: 10, search: "trim")

# Get a specific tool by slug
tool = client.get_tool("video-trim")
puts "#{tool["name"]}: #{tool["description"]}"

# Search across all content
results = client.search("trim")
puts "Found #{results["results"]["tools"].length} tools"

# Browse the glossary
glossary = client.list_glossary(search: "mp4")
glossary["results"].each do |term|
  puts "#{term["term"]}: #{term["definition"]}"
end

# Discover guides
guides = client.list_guides(category: "video")
guides["results"].each do |guide|
  puts "#{guide["title"]} (#{guide["audience_level"]})"
end

# List file format conversions
conversions = client.list_conversions(source: "webm")

# Get format details
format = client.get_format("webm")
puts "#{format["name"]} (#{format["extension"]}): #{format["mime_type"]}"
```

### Available Methods

| Method | Description |
|--------|-------------|
| `list_tools` | List tools (paginated, filterable) |
| `get_tool(slug)` | Get tool by slug |
| `list_categories` | List tool categories |
| `list_formats` | List file formats |
| `get_format(slug)` | Get format by slug |
| `list_conversions` | List format conversions |
| `list_glossary` | List glossary terms |
| `get_glossary_term(slug)` | Get glossary term |
| `list_guides` | List guides |
| `get_guide(slug)` | Get guide by slug |
| `list_use_cases` | List use cases |
| `search(query)` | Search across all content |
| `list_sites` | List Peasy sites |
| `openapi_spec` | Get OpenAPI specification |

All list methods accept keyword arguments: `page:`, `limit:`, `category:`, `search:`.

Full API documentation at [peasyvideo.com/developers/](https://peasyvideo.com/developers/).
OpenAPI 3.1.0 spec: [peasyvideo.com/api/openapi.json](https://peasyvideo.com/api/openapi.json).

## Learn More About Video Tools

- **Tools**: [Video Resolution Calculator](https://peasyvideo.com/video/video-resolution/) · [Video Bitrate Calculator](https://peasyvideo.com/video/video-bitrate/) · [Video Framerate Converter](https://peasyvideo.com/video/video-framerate/) · [All Tools](https://peasyvideo.com/)
- **Guides**: [Video Codecs Explained](https://peasyvideo.com/guides/video-codecs-explained/) · [Video Compression for Web Delivery](https://peasyvideo.com/guides/video-compression-web-delivery/) · [All Guides](https://peasyvideo.com/guides/)
- **Glossary**: [AV1](https://peasyvideo.com/glossary/av1/) · [Frame Rate](https://peasyvideo.com/glossary/frame-rate/) · [Color Grading](https://peasyvideo.com/glossary/color-grading/) · [All Terms](https://peasyvideo.com/glossary/)
- **Formats**: [MP4](https://peasyvideo.com/formats/mp4/) · [WebM](https://peasyvideo.com/formats/webm/) · [All Formats](https://peasyvideo.com/formats/)
- **API**: [REST API Docs](https://peasyvideo.com/developers/) · [OpenAPI Spec](https://peasyvideo.com/api/openapi.json)

## Also Available

| Language | Package | Install |
|----------|---------|---------|
| **Python** | [peasy-video](https://pypi.org/project/peasy-video/) | `pip install "peasy-video[all]"` |
| **TypeScript** | [peasy-video](https://www.npmjs.com/package/peasy-video) | `npm install peasy-video` |
| **Go** | [peasy-video-go](https://pkg.go.dev/github.com/peasytools/peasy-video-go) | `go get github.com/peasytools/peasy-video-go` |
| **Rust** | [peasy-video](https://crates.io/crates/peasy-video) | `cargo add peasy-video` |

## Peasy Developer Tools

Part of the [Peasy Tools](https://peasytools.com) open-source developer ecosystem.

| Package | PyPI | npm | RubyGems | Description |
|---------|------|-----|----------|-------------|
| peasy-pdf | [PyPI](https://pypi.org/project/peasy-pdf/) | [npm](https://www.npmjs.com/package/peasy-pdf) | [Gem](https://rubygems.org/gems/peasy-pdf) | PDF merge, split, rotate, compress — [peasypdf.com](https://peasypdf.com) |
| peasy-image | [PyPI](https://pypi.org/project/peasy-image/) | [npm](https://www.npmjs.com/package/peasy-image) | [Gem](https://rubygems.org/gems/peasy-image) | Image resize, crop, convert, compress — [peasyimage.com](https://peasyimage.com) |
| peasy-audio | [PyPI](https://pypi.org/project/peasy-audio/) | [npm](https://www.npmjs.com/package/peasy-audio) | [Gem](https://rubygems.org/gems/peasy-audio) | Audio trim, merge, convert, normalize — [peasyaudio.com](https://peasyaudio.com) |
| **peasy-video** | [PyPI](https://pypi.org/project/peasy-video/) | [npm](https://www.npmjs.com/package/peasy-video) | [Gem](https://rubygems.org/gems/peasy-video) | **Video trim, resize, thumbnails, GIF — [peasyvideo.com](https://peasyvideo.com)** |
| peasy-css | [PyPI](https://pypi.org/project/peasy-css/) | [npm](https://www.npmjs.com/package/peasy-css) | [Gem](https://rubygems.org/gems/peasy-css) | CSS minify, format, analyze — [peasycss.com](https://peasycss.com) |
| peasy-compress | [PyPI](https://pypi.org/project/peasy-compress/) | [npm](https://www.npmjs.com/package/peasy-compress) | [Gem](https://rubygems.org/gems/peasy-compress) | ZIP, TAR, gzip compression — [peasytools.com](https://peasytools.com) |
| peasy-document | [PyPI](https://pypi.org/project/peasy-document/) | [npm](https://www.npmjs.com/package/peasy-document) | [Gem](https://rubygems.org/gems/peasy-document) | Markdown, HTML, CSV, JSON conversion — [peasyformats.com](https://peasyformats.com) |
| peasytext | [PyPI](https://pypi.org/project/peasytext/) | [npm](https://www.npmjs.com/package/peasytext) | [Gem](https://rubygems.org/gems/peasytext) | Text case conversion, slugify, word count — [peasytext.com](https://peasytext.com) |

## License

MIT
