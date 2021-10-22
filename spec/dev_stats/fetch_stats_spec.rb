# frozen_string_literal: true

RSpec.describe DevStats::FetchStats do
  it "can fetch stats" do
    stub_api("users/me", { "username" => "bob" })
    stub_api("articles?per_page=1000&username=bob", articles_response)
    stub_api("followers/users?per_page=1000", followers_response)

    fetcher = described_class.new(api_key: ENV.fetch("DEV_API_KEY"))

    stats = fetcher.latest_stats

    expect(stats.username).to eq("bob")
    expect(stats.reactions).to eq(114)
    expect(stats.comments).to eq(13)
    expect(stats.followers).to eq(32)
  end

  def stub_api(path, body)
    response = JSON.dump(body)
    stub_request(:get, "https://dev.to/api/#{path}").
      to_return(body: response, status: 200,
        headers: { "Content-Length" => response.length, "Content-Type" => "application/json" })
  end

  def articles_response
    [
      {
        "public_reactions_count" => 98,
        "comments_count" => 11,
      },
      {
        "public_reactions_count" => 16,
        "comments_count" => 2,
      },
    ]
  end

  def followers_response
    32.times.map do
      { "username" => "user-#{rand}" }
    end
  end
end
