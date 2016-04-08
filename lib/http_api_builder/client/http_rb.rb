require 'http'
require 'addressable/template'

module HttpApiBuilder
  module Client
    # A demonstration implementation, using HTTP.rb
    # This is functional and pretty much production ready, but you can
    # easily rewrite it to use curb or typhoeus or anything else really
    module HttpRb
      def request(verb, url, form:, query:, body:, json:) # rubocop:disable Metrics/ParameterLists
        HTTP.send(verb, url, form: form, params: query, body: body, json: json)
      end
    end
  end
end
