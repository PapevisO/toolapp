module GithubManager
  RESULTS = [
    SUCCESS = :success,
    FAILURE = :failure
  ]

  BaseServiceConfig = Struct.new(:owner_repo, :branch)

  class BaseService < ApplicationService
    include ActiveSupport::Configurable

    config_accessor(:owner_repo) { 'PapevisO/toolapp-specs' }
    config_accessor(:branch) { ENV['RAILS_ENV'] == 'test' ? 'test' : 'master' }
    config_accessor(:access_token) { ENV['GITHUB_ACCESS_TOKEN'] }
  end

  class ToolResult
    attr_reader :state, :filename, :is_master, :json_raw, :json

    def initialize(state, filename = nil, is_master = nil, json_raw = nil)
      @state = state
      @filename = filename
      @is_master = is_master
      @json_raw = json_raw
      @json = JSON.parse(json_raw) if json_raw
    rescue JSON::ParserError
      @state = FAILURE
      @json_invalid = true
    end

    # other context legacy mapper
    def path
      @filename
    end

    def success
      @state == SUCCESS
    end

    def failure
      @state == FAILURE
    end

    def failed
      @state == FAILURE
    end

    def fail
      @state == FAILURE
    end

    def json_invalid
      !!@json_invalid
    end
  end
end
