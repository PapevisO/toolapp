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

    def config
      self.class.config
    end
  end

  class ToolResult
    attr_reader :state, :filename, :json_raw, :json

    def initialize(state, filename = nil, is_master = nil, json_raw = nil)
      @state = state
      @filename = filename
      @is_master = is_master
      @json_raw = json_raw
      @json = JSON.parse(json_raw) if json_raw
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
  end
end
