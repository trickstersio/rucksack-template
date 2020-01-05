module Alive
  module Endpoints
    class Alive < Endpoint
      def handle
        render status: 200, body: json({
          alive: true,
          timestamp: Time.now.utc.iso8601,
          database: {
            alive: ActiveRecord::Base.connection.active?
          }
        })
      end
    end
  end
end
