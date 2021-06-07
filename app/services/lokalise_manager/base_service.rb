module LokaliseManager
  RESULTS = [
    SUCCESS = :success,
    FAILURE = :failure
  ]

  class BaseService < ApplicationService
    include ActiveSupport::Configurable

    config_accessor(:project_id)
    config_accessor(:api_key)
  end

  class LokaliseResult
    attr_reader :state, :presented

    def initialize(state, presented = nil)
      @presented = presented
      @state = presented ? state : FAILURE
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
