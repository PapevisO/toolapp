require 'test_helper'

module GithubManagerServiceTest
  class ToolFetcherServiceTest < ActiveSupport::TestCase
    test '#call successfully fetches tool when master is present on remote' do
      tool = tools :master_tool
      tool_fetcher_service = GithubManager::ToolFetcher.call tool
      assert tool_fetcher_service.success
      assert tool_fetcher_service.is_master
    end

    test '#call successfully fetches tool when slave but not master is present on remote' do
      tool = tools :slave_tool
      tool_fetcher_service = GithubManager::ToolFetcher.call tool
      assert tool_fetcher_service.success
      assert_not tool_fetcher_service.is_master
    end

    test '#call fails to fetch tool when neither master nor slave are present on remote' do
      tool = tools :missing_tool
      tool_fetcher_service = GithubManager::ToolFetcher.call tool
      assert tool_fetcher_service.failed
    end

    test '#call fails to fetch tool when tool is present on remote but has invalid json contents' do
      tool = tools :invalid_tool
      tool_fetcher_service = GithubManager::ToolFetcher.call tool
      assert tool_fetcher_service.failed
      assert tool_fetcher_service.json_invalid
    end
  end
end
