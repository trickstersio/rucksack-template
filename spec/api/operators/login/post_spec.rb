RSpec.describe "/operators/login" do
  let!(:operator) { create(:operator, password: password, password_confirmation: password) }

  let(:email) { operator.email }
  let(:password) { SecureRandom.hex(4) }

  let(:headers) do
    {
      "Accept" => "application/json"
    }
  end

  let(:body) do
    {
      credentials: {
        email: email,
        password: password
      }
    }
  end

  before do
    headers.each { |key, value| header key, value }
  end

  it "responds with 200" do
    post "/operators/login", body.to_json
    expect(last_response.status).to eq(200)
  end

  context "when credentials is wrong" do
    before do
      body[:credentials] = { email: "wrong@example.com", password: "12345" }
    end

    it "responds with 422" do
      post "/operators/login", body.to_json
      expect(last_response.status).to eq(422)
    end
  end
end
