module GithubManager
  class ToolFetcher < BaseService
    attr_reader :tool_name, :tool_language, :paths

    def initialize(tool_or_tool_name, tool_language = 'en')
      if tool_or_tool_name.instance_of?(Tool)
        initialize_with_tool_params tool_or_tool_name.name, tool_or_tool_name.language
      elsif tool_or_tool_name.instance_of?(String)
        initialize_with_tool_params tool_or_tool_name, tool_language
      else
        @paths = nil
      end
    end

    def call
      return false unless @paths

      try_fetch
    end

    private

    def initialize_with_tool_params(tool_name, tool_language)
      @paths = {
        master: [tool_name, tool_language, 'master', 'json'].join('.'),
        slave: [tool_name, tool_language, 'json'].join('.')
      }
    end

    def try_fetch(master = false)
      path = @paths[master ? :master : :slave]
      require 'pry'; ::Kernel.binding.pry
      github_api_response = Octokit.contents config.owner_repo, path: path, ref: config.branch

      ToolResult.new(
        SUCCESS,
        path,
        master,
        Base64.decode64(
          github_api_response.content
        )
      )
    rescue Octokit::NotFound => e
      return try_fetch(true) unless master && !github_api_response

      # if attempt to fetch master failed assume fetch slave also failed
      ToolResult.new(
        FAILURE,
        path
      )
    end
  end
end
