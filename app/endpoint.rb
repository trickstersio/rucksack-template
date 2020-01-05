class Endpoint < Rucksack::Endpoint
  class AuthenticationRequired < StandardError; end

  register_rescue_callback Sessions::Owners::InvalidPayload, Sessions::Owners::InvalidKind do
    halt! status: 401
  end

  register_rescue_callback Endpoint::AuthenticationRequired do
    halt! status: 401
  end

  register_rescue_callback ActiveRecord::RecordNotFound, Action::AccessDenied do
    halt! status: 404
  end

  def self.authenticate!
    register_before_callback do
      if current_user.nil?
        raise Endpoint::AuthenticationRequired
      end
    end
  end

  protected def current_user
    @current_user ||= current_session.owner
  rescue Sessions::Owners::InvalidPayload, Sessions::Owners::InvalidKind
    nil
  end

  protected def current_session
    @current_session ||= Sessions::Session.new(access_token)
  end

  protected def access_token
    @access_token ||= request.env["HTTP_X_ACCESS_TOKEN"]
  end

  protected def logger
    Application.logger
  end
end
