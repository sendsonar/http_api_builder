require 'http_api_builder/version'
require 'http_api_builder/dsl'
require 'http_api_builder/helpers'

module HttpApiBuilder
  # A basic HTTP client. Meant to be extended from.
  class BaseClient
    extend Dsl
    include Helpers

    def initialize(); end

    # Perform the request, post processors, and return the result
    def perform(method, path, form: nil, query: nil, body: nil, json: nil, &_block) # rubocop:disable Metrics/ParameterLists
      url = build_url(path)
      response = request(method, url, form: form, query: query, body: body, json: json)
      status = response.status
      resource = response.body
      block_given? ? yield(resource, status, response) : resource
    end

    # Placeholder for your request method.
    # Accepts these params, for you to do whatever you like with. See the HTTPrb_client implementation
    #
    # @param [Symbol] method The HTTP VERB to use
    # @param [URI] uri The url to make the request to
    # @param [Hash] form: nil Form data, for encoding into HTTP form encoding
    # @param [Hash] query: nil Query key/value pairs
    # @param [String] body: nil A raw body
    # @param [Hash, Array] json: nil Hash/Array data to be encoded as JSON.
    def request(*)
      raise 'HttpApiBuilder::BaseClient#request must be implemented, see documentation'
    end
  end
end
