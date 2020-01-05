module Sessions
  module Endpoints
    class Create < Endpoint
      def handle
        action = Sessions::Actions::Create.new(args)
        action.execute!

        if action.success?
          render status: 200, body: json(Sessions::Presenters::Show.new(action.session).as_json)
        else
          render status: 422, body: json(Errors.new(action.errors).as_json)
        end
      end

      private def args
        {
          kind: request.params[:kind],
          credentials: request.json[:credentials]
        }
      end
    end
  end
end
