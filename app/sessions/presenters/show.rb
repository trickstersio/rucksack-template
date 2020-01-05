module Sessions
  module Presenters
    class Show < Presenter
      class UnknownSessionOwnerError < StandardError; end

      def initialize(session)
        @session = session
      end

      def as_json
        {
          token: @session.token,
          owner: Sessions::Owners.for(@session.kind).as_json(@session.owner)
        }
      end
    end
  end
end
