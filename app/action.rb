class Action < Performify::Base
  class AccessDenied < StandardError; end

  protected def access_denied!
    raise Action::AccessDenied
  end
end
