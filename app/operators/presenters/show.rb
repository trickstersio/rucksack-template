module Operators
  module Presenters
    class Show < Presenter
      def initialize(operator)
        @operator = operator
      end

      def as_json
        {
          id: @operator.id,
          email: @operator.email,
          created_at: @operator.created_at.utc.iso8601,
          updated_at: @operator.updated_at.utc.iso8601
        }
      end
    end
  end
end
