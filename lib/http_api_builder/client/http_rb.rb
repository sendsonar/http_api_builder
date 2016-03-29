require 'http'

module HttpApiBuilder
  module Client
    # A demonstration implementation, using HTTP.rb
    # This is functional and pretty much production ready, but you can
    # easily rewrite it to use curb or typhoeus or anything else really
    module HttpRb
      def request(verb, path, form:, query:, body:, json:) # rubocop:disable Metrics/ParameterLists
        url = URI.join(self.class.base_url || '', path)
        HTTP.send(verb, url, form: form, params: query, body: body, json: json)
      end
    end
  end
end
