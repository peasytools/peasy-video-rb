# frozen_string_literal: true

require "net/http"
require "json"
require "uri"

module PeasyVideo
  # REST API client for peasyvideo.com.
  # Zero dependencies — uses Ruby stdlib only.
  class Client
    DEFAULT_BASE_URL = "https://peasyvideo.com"

    def initialize(base_url: DEFAULT_BASE_URL)
      @base_url = base_url.chomp("/")
    end

    # --- Tools ---

    def list_tools(page: 1, limit: 50, category: nil, search: nil)
      get("/api/v1/tools/", page: page, limit: limit, category: category, search: search)
    end

    def get_tool(slug)
      get("/api/v1/tools/#{slug}/")
    end

    # --- Categories ---

    def list_categories(page: 1, limit: 50)
      get("/api/v1/categories/", page: page, limit: limit)
    end

    # --- Formats ---

    def list_formats(page: 1, limit: 50, category: nil, search: nil)
      get("/api/v1/formats/", page: page, limit: limit, category: category, search: search)
    end

    def get_format(slug)
      get("/api/v1/formats/#{slug}/")
    end

    # --- Conversions ---

    def list_conversions(page: 1, limit: 50, source: nil, target: nil)
      get("/api/v1/conversions/", page: page, limit: limit, source: source, target: target)
    end

    # --- Glossary ---

    def list_glossary(page: 1, limit: 50, category: nil, search: nil)
      get("/api/v1/glossary/", page: page, limit: limit, category: category, search: search)
    end

    def get_glossary_term(slug)
      get("/api/v1/glossary/#{slug}/")
    end

    # --- Guides ---

    def list_guides(page: 1, limit: 50, category: nil, audience_level: nil, search: nil)
      get("/api/v1/guides/", page: page, limit: limit, category: category,
                              audience_level: audience_level, search: search)
    end

    def get_guide(slug)
      get("/api/v1/guides/#{slug}/")
    end

    # --- Use Cases ---

    def list_use_cases(page: 1, limit: 50, industry: nil, search: nil)
      get("/api/v1/use-cases/", page: page, limit: limit, industry: industry, search: search)
    end

    # --- Search ---

    def search(query, limit: 20)
      get("/api/v1/search/", q: query, limit: limit)
    end

    # --- Sites ---

    def list_sites
      get("/api/v1/sites/")
    end

    # --- OpenAPI ---

    def openapi_spec
      get("/api/openapi.json")
    end

    private

    def get(path, **params)
      uri = URI("#{@base_url}#{path}")
      params.reject! { |_, v| v.nil? }
      uri.query = URI.encode_www_form(params) unless params.empty?
      response = Net::HTTP.get_response(uri)
      body = JSON.parse(response.body)
      unless response.is_a?(Net::HTTPSuccess)
        detail = body.is_a?(Hash) ? body.fetch("detail", "Unknown error") : response.body
        raise PeasyVideo::Error, "HTTP #{response.code}: #{detail}"
      end
      body
    end
  end
end
