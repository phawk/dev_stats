# frozen_string_literal: true

require "pstore"
require "readline"
require_relative "dev_stats/version"
require_relative "dev_stats/stats"
require_relative "dev_stats/fetch_stats"
require_relative "dev_stats/display"

module DevStats
  class Error < StandardError; end

  class CLI
    def run
      request_api_key unless api_key

      stats = FetchStats.new(api_key: api_key).latest_stats
      puts Display.new.render(stats)
    end

    def api_key
      @_api_key = store.transaction(true) do |store|
        store["api_key"]
      end
    end

    def request_api_key
      puts "What is your dev.to API key?"
      @_api_key = api_key = Readline.readline("> ", true)

      store.transaction do |store|
        store["api_key"] = api_key
      end

      # Clear this output
      print "\r" + ("\e[A\e[K"*2)
    end

    private

    def store
      PStore.new(File.expand_path("~/devstats.pstore"))
    end
  end
end
