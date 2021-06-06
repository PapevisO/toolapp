module LokaliseManager
  class JsonNormalizer < BaseService
    INTERNAL_DELIMITER = ' key_value_delimiter '
    NORMALIZER_FILTER = %w[
      language
      result
      sections
      infoSections
    ]

    def initialize(json_or_hash)
      @parsed_json = if json_or_hash.respond_to?(:keys)
                       json_or_hash
                     elsif json_or_hash.instance_of?(String)
                       JSON.parse json_or_hash
                     end
    end

    def call
      return fail unless @parsed_json

      normalize_parsed_json
      lokalise_presenter
      return fail unless @presented

      LokaliseResult.new(
        SUCCESS,
        @presented
      )
    end

    private

    def fail
      LokaliseResult.new(
        FAILURE,
        nil
      )
    end

    def deep_reject(hash, &block)
      hash.each_with_object({}) do |(k, v), memo|
        next if block.call(k, v)

        memo[k] = if v.is_a?(Hash)
                    deep_reject(v, &block)
                  else
                    v
                  end
      end
    end

    def deep_underscore_keys(hash)
      hash.flat_map do |k, v|
        if v.respond_to?(:key)
          deep_underscore_keys(v).map { |str| "#{k}_#{str}" }
        else
          "#{k}#{INTERNAL_DELIMITER}#{v}"
        end
      end
    end

    def normalize_parsed_json
      @normalized = deep_reject(@parsed_json) do |_k, value|
        !value.instance_of?(String) && !value.respond_to?(:keys)
      end

      @tool_name = @normalized['id']
      @normalized.delete_if do |key, _v|
        !NORMALIZER_FILTER.include? key
      end
    end

    def lokalise_presenter
      @presented = Hash[
        deep_underscore_keys(@normalized).map do |key_value|
          key_value = key_value.split INTERNAL_DELIMITER
          key_value[0] = "#{@tool_name}_#{key_value[0]}"
          key_value
        end
      ]
    end
  end
end
