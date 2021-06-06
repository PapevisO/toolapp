module LokaliseManager
  RESULTS = [
    SUCCESS = :success,
    FAILURE = :failure
  ]

  class BaseService < ApplicationService
    include ActiveSupport::Configurable

    config_accessor(:project_id) { '9550531960ace5380abb23.11391582' }
    config_accessor(:api_key) { '02b0408c8268b29922a2b7a1fe8233ff3f783e89' }
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
