# frozen_string_literal: true

require "dotenv"
require_relative "dev_stats/version"
require_relative "dev_stats/stats"
require_relative "dev_stats/fetch_stats"
require_relative "dev_stats/display"

Dotenv.load

module DevStats
  class Error < StandardError; end

  class CLI
    def run
      stats = FetchStats.new(api_key: ENV.fetch("DEV_API_KEY")).latest_stats
      STDOUT.puts Display.new.render(stats)
    end
  end
end
