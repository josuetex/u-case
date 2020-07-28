# frozen_string_literal: true

module Micro
  class Case
    module Error
      class UnexpectedResult < TypeError
        MESSAGE = '#call! must return an instance of Micro::Case::Result'.freeze

        def initialize(klass); super(klass.name + MESSAGE); end
      end

      class ResultIsAlreadyDefined < ArgumentError
        def initialize; super('result is already defined'.freeze); end
      end

      class InvalidResultType < TypeError
        def initialize; super('type must be a Symbol'.freeze); end
      end

      class InvalidResult < TypeError
        BASE = "The result returned from %{use_case}#call! must be a Hash.\n\nExample:"
        CUSTOM_TYPE = "%{result}(:%{custom_type}, result: { key: 'value' })"
        DEFAULT_TYPE = "%{result}(result: { key: 'value' })"

        def initialize(is_success, type, use_case)
          result = is_success ? 'Success'.freeze : 'Failure'.freeze

          example =
            if type === :ok || type === :error || type === :exception
              DEFAULT_TYPE % { result: result }
            else
              CUSTOM_TYPE % { result: result, custom_type: type }
            end

          super("#{BASE % { use_case: use_case.class.name }}\n  #{example}")
        end
      end

      class InvalidResultInstance < ArgumentError
        def initialize; super('argument must be an instance of Micro::Case::Result'.freeze); end
      end

      class InvalidUseCase < TypeError
        def initialize; super('use case must be a kind or an instance of Micro::Case'.freeze); end
      end

      class InvalidInvocationOfTheThenMethod < StandardError
        def initialize; super('Invalid invocation of the Micro::Case::Result#then method'); end
      end

      class InvalidAccessToTheUseCaseObject < StandardError
        def initialize; super('only a failure result can access its use case object'.freeze); end
      end

      def self.by_wrong_usage?(exception)
        exception.is_a?(InvalidResult) || exception.is_a?(UnexpectedResult) || exception.is_a?(ArgumentError)
      end
    end
  end
end
