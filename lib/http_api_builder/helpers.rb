module HttpApiBuilder
  # Helper methods
  module Helpers
    protected

    # Validates arguments and ensures that required and optional are present.
    # Also validates that all args are expected
    #
    # @param [Array] actual The args (or keys of args) we've received
    # @param [Array] required Args we are required to have, will raise error if not present
    # @param [Array] optional Optional args.
    def validate_args!(actual, required, optional)
      validate_required_arguments(actual, required)
      validate_valid_arguments(actual, required, optional)
    end

    private

    # Start the processing chain for the response object
    # Processors work in a chain, meaning order of operations is important.
    # The first processor gets the raw result, the second processor the first's
    # output and so forth.
    # The last processor's output is the return of the method
    # processors: [processor1, processor2] yields this pipeline:
    # request -> processor1 -> processor2 -> output
    def run_processors(resource, processors)
      Array(processors).reduce(resource) do |data, processor|
        if processor.respond_to?(:call)
          processor.call(data)
        else
          send(processor, data)
        end
      end
    end

    # Build the path, filling in any interpolation tokens
    #
    # @param [String] path
    # @param [Hash] values Key-value {interpolation: value}
    # @return [String] interpolated string
    def interpolate_path(path, values)
      result = path.dup
      values.each do |token, value|
        token = ":#{token}"
        result.gsub!(token, value)
      end
      result
    end

    # Get the non-interpolating query parameters
    def query_params(path, params, required, optional)
      path_params = self.class.send(:interpolated_params, path)
      query_keys  = (required + (optional - [:data])) - path_params
      params.select { |k, _| query_keys.include? k }
    end

    # Raise an ArgumentError if not everything listed as required is not listed in supplied.
    #
    def validate_required_arguments(supplied, required)
      missing = required - supplied
      return if missing.empty?

      raise ArgumentError, "missing required arguments: #{missing.join(', ')}"
    end

    # Raise an ArgumentError if not everything listed in supplied appear in either the required or optional list.
    #
    def validate_valid_arguments(supplied, required, optional)
      unrecognized = supplied - (required + optional).uniq
      return if unrecognized.empty?

      raise ArgumentError, "unrecognized arguments: #{unrecognized.join(', ')}"
    end

    # Handle's building paths
    def build_url(path)
      parsed_base = URI.parse(self.class.base_url)
      parsed_basepath = parsed_base.path.split('/').reject(&:empty?)

      addressable_path = URI.parse(path)

      return addressable_path unless addressable_path.relative?
      parsed_path = addressable_path.path.split('/').reject(&:empty?)

      parsed_basepath += parsed_path

      parsed_base.path = '/' + parsed_basepath.join('/')

      parsed_base
    end
  end
end
