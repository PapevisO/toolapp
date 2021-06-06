require 'test_helper'

module GithubManagerServiceTest
  class ToolFetcherServiceTest < ActiveSupport::TestCase
    test '#call successfully fetches tool when slave present on remote' do
      # require 'pry'; ::Kernel.binding.pry
      tool = tools :one
      tool_fetcher_service = GithubManager::ToolFetcher.call tool
      assert tool_fetcher_service.success
    end

    test '#call fails to fetch tool when neither master nor slave are present on remote' do
      tool = tools :two
      tool_fetcher_service = GithubManager::ToolFetcher.call tool
      assert tool_fetcher_service.failed
    end
  end
end
