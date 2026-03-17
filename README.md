# peasy-video

[![Gem Version](https://badge.fury.io/rb/peasy-video.svg)](https://rubygems.org/gems/peasy-video)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Ruby client for the [PeasyVideo](https://peasyvideo.com) API — trim, resize, rotate, extract audio, generate thumbnails, and convert to GIF. Zero dependencies beyond Ruby stdlib (Net::HTTP, JSON, URI).

Built from [PeasyVideo](https://peasyvideo.com), a free online video toolkit with tools for every video workflow — trim clips to exact timestamps, resize dimensions, generate thumbnail grids, extract audio tracks, and create animated GIFs.

> **Try the interactive tools at [peasyvideo.com](https://peasyvideo.com)** — [Video Tools](https://peasyvideo.com/), [Video Glossary](https://peasyvideo.com/glossary/), [Video Guides](https://peasyvideo.com/guides/)

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

## Learn More

- **Tools**: [Video Resolution Calculator](https://peasyvideo.com/video/video-resolution/) · [Video Bitrate Calculator](https://peasyvideo.com/video/video-bitrate/) · [Video Framerate Converter](https://peasyvideo.com/video/video-framerate/) · [All Tools](https://peasyvideo.com/)
- **Guides**: [Video Codecs Explained](https://peasyvideo.com/guides/video-codecs-explained/) · [Video Compression for Web](https://peasyvideo.com/guides/video-compression-web-delivery/) · [All Guides](https://peasyvideo.com/guides/)
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
