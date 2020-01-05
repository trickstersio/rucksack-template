RSpec.describe "GET /" do
  let(:headers) do
    {
      "Accept" => "application/json"
    }
  end

  before do
    headers.each { |key, value| header key, value }
  end

  it "responds with 200" do
    get "/"
    expect(last_response.status).to eq(200)
  end
end
