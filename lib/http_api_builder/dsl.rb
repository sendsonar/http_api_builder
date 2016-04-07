require 'forwardable'

module HttpApiBuilder
  # Module for restful api dsl commands
  module Dsl
    VERBS =
      %i(get head post put delete trace options connect) + # HTTP 1.1
      %i(propfind proppatch mkcol copy move lock unlock) + # WebDAV
      %i(orderpatch) + # WebDAV Ordered Collections protocol
      %i(acl) + # WebDAV Access Control protocol
      %i(patch) + # PATCH method for HTTP
      %i(search) # WebDAV search

    # Set the initial URL used by the gem
    def base_url(value = nil)
      value.nil? ? @base_url : (@base_url = value)
    end

    protected

    # Generate whiny and quiet API consumer methods.
    #
    # Whiny methods have a bang suffix and raise errors if they fail
    # Quiet methods do not have the bang suffix and return nil if they fail
    #
    # eg:
    #   endpoint '/path', as: :mymethod
    # results in:
    #   mymethod! <-- whiny
    #   mymethod  <-- quiet
    def endpoint(path, as:, using: :get, params: nil, form: nil, body: nil, processors: nil, json: nil) # rubocop:disable Metrics/ParameterLists
      def_whiny_method as, path, using, processors, params, form, body, json
      def_quiet_method as
    end

    VERBS.each do |v|
      define_method v do |path, **opts|
        endpoint path, using: v, **opts
      end
    end

    private

    # Generate a consumer method that raises exceptions when requests raise an error
    #
    def def_whiny_method(name, path, using, processors, params, form, body, json) # rubocop:disable Metrics/ParameterLists, Metrics/AbcSize, Metrics/MethodLength
      required, optional = requirements(path, params)

      define_method :"#{name}!" do |opts = {}|
        validate_args! opts.keys, required, optional

        reqpath = interpolate_path(path, opts)
        query = query_params(path, opts, required, optional)

        form = Hash(form).merge(Hash(opts[:form]))
        json = opts[:json] || json
        body = opts[:body] || body
        perform(using, reqpath, form: form, query: query, body: body, json: json) do |resource, *_|
          run_processors resource, processors
        end
      end
    end

    # Generate a consumer method that returns nil when requests raise errors
    #
    def def_quiet_method(name)
      define_method name do |opts = {}|
        begin
          send(:"#{name}!", opts)
        rescue StandardError
          nil
        end
      end
    end

    # Extract param segments from a path, paperclip style. Returns an array of symbols matching the names of the param segments.
    #
    # Param segments are sections of the path that begin with `:`, and run to the next /
    def interpolated_params(path)
      path.split('/').reject { |i| i.length.zero? || i !~ /^:/ }.uniq.map { |i| i[1..-1].to_sym }
    end

    # Parse out and return the required and optional arguments
    #
    # Required are any that are in the URL or in the required hash
    # Optional are any other arguments.
    def requirements(path, params)
      required, optional = Hash(params).values_at(*%i(required optional)).map { |list| Array(list) }

      required += interpolated_params(path)

      [required, optional]
    end
  end
end
