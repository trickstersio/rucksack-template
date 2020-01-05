require_relative "config/initialize"

use Rack::Session::Cookie,
  secret: Application.configuration.session_secret,
  domain: Application.configuration.public_url.host


use Rack::Cors do
  allow do
    origins "*"
    resource "/*",
      headers: :any,
      methods: %i(get post put patch delete options head)
  end
end

run Application.boot(Router.new)
