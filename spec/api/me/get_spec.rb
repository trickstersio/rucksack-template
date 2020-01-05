RSpec.describe "GET /me" do
  let(:headers) do
    {
      "Accept" => "application/json",
      "X-Access-Token" => access_token
    }
  end

  let(:current_user) { create(:operator) }
  let(:access_token_kind) { Sessions::Owners::Operator::KIND }
  let(:access_token) { Sessions::Session.token(access_token_kind, current_user) }

  before do
    headers.each { |key, value| header key, value }
  end

  it "responds with 200" do
    get "/me"
    expect(last_response.status).to eq(200)
  end

  it "responds with operator as an owner" do
    get "/me"
    expect(last_response_json[:owner]).to eq(Operators::Presenters::Show.new(current_user).as_json)
  end

  context "when access token is invalid" do
    let(:access_token) { SecureRandom.hex(16) }

    it "responds with 401" do
      get "/me"
      expect(last_response.status).to eq(401)
    end
  end
end
