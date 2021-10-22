# frozen_string_literal: true

require "pstore"
require "readline"
require_relative "dev_stats/version"
require_relative "dev_stats/stats"
require_relative "dev_stats/fetch_stats"
require_relative "dev_stats/display"
require_relative "dev_stats/cached_stats"

module DevStats
  class Error < StandardError; end

  class CLI
    def run
      request_api_key unless api_key

      display = Display.new
      cached_stats = CachedStats.new(store)

      puts display.render(cached_stats.fetch) if cached_stats.fetch
      puts "Refreshing stats..."

      stats = FetchStats.new(api_key: api_key).latest_stats
      cached_stats.save(stats)
      clear_lines(display.rendered_lines + 1)
      puts display.render(stats)
      puts "Stats refreshed!"
    end

    def api_key
      @_api_key = store.transaction(true) do |store|
        store["api_key"]
      end
    end

    def request_api_key
      puts "What is your dev.to API key? (https://dev.to/settings/account)"
      @_api_key = api_key = Readline.readline("> ", true)

      store.transaction do |store|
        store["api_key"] = api_key
      end

      clear_lines(2)
    end

    private

    def clear_lines(count = 1)
      print "\r" + ("\e[A\e[K"*count)
    end

    def store
      PStore.new(File.expand_path("~/devstats.pstore"))
    end
  end
end
