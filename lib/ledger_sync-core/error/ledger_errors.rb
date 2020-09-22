# frozen_string_literal: true

module LedgerSync
  class Error
    class LedgerError < Error
      attr_reader :client
      attr_reader :response

      def initialize(client:, message:, response: nil)
        @client = client
        @response = response
        super(message: message)
      end

      class AuthenticationError < self; end
      class AuthorizationError < self; end
      class ConfigurationError < LedgerSync::Error; end

      class LedgerValidationError < self
        attr_reader :attribute, :validation

        def initialize(message:, client:, attribute:, validation:)
          @attribute = attribute
          @validation = validation
          super(
            message: message,
            client: client,
          )
        end
      end
    end
  end
end
