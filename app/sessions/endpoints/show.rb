module Sessions
  module Endpoints
    class Show < Endpoint
      authenticate!

      def handle
        render status: 200, body: json(Sessions::Presenters::Show.new(current_session).as_json)
      end
    end
  end
end
