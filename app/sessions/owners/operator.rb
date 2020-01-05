module Sessions
  module Owners
    class Operator < Sessions::Owners::Base
      def deserialize(payload)
        operator = Models::Operator.find_by(id: payload[:id])

        if operator.nil?
          raise Sessions::Owners::InvalidPayload, "Failed to find operator by given session"
        end

        operator
      end

      def serialize(operator)
        {
          id: operator.id
        }
      end

      def as_json(operator)
        Operators::Presenters::Show.new(operator).as_json
      end

      def authenticate(credentials)
        if credentials[:email].nil? || credentials[:password].nil?
          return
        end

        operator = Models::Operator.find_by(email: credentials[:email])

        if operator.nil?
          return
        end

        if !operator.authenticate(credentials[:password])
          return
        end

        Sessions::Session.for(Sessions::Owners::Operator::KIND, operator)
      end
    end
  end
end
