require "net/http"
require "json"

module DevStats
  class Stats < Struct.new(:reactions, :comments, :followers); end
  class FetchStats
    def initialize(api_key:)
      @api_key = api_key
    end

    def latest_stats
      user = get_json("https://dev.to/api/users/me")
      username = user["username"]

      articles = get_json("https://dev.to/api/articles?per_page=1000&username=#{username}")
      reactions = articles.inject(0) { |memo, article| memo += article["public_reactions_count"] }
      comments = articles.inject(0) { |memo, article| memo += article["comments_count"] }
      all_followers = get_json("https://dev.to/api/followers/users?per_page=1000")
      follower_count = all_followers.size

      Stats.new(reactions, comments, follower_count)
    end

    private

    def get_json(url)
      uri  = URI(url)
      req = Net::HTTP::Get.new(uri)
      req["api-key"] = @api_key

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http|
        http.request(req)
      }

      if res.is_a?(Net::HTTPSuccess)
        JSON.parse(res.body)
      else
        nil
      end
    end
  end
end
