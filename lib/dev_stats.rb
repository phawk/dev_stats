# frozen_string_literal: true

require "thor"
require "pstore"
require "readline"
require_relative "dev_stats/version"
require_relative "dev_stats/stats"
require_relative "dev_stats/fetch_stats"
require_relative "dev_stats/display"
require_relative "dev_stats/cached_stats"

module DevStats
  class Error < StandardError; end

  class CLI < Thor
    package_name "DevStats"
    default_task :stats

    desc "stats", "Shows available dev.to stats"
    def stats
      ensure_logged_in!

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

    desc "logout", "Wipes all data and your API key"
    def logout
      File.unlink(File.expand_path("~/devstats.pstore"))
      puts "Data wiped."
    end

    desc "auth", "Logging using your dev.to api_key"
    def auth
      puts "What is your dev.to API key? (https://dev.to/settings/account)"
      @_api_key = api_key = Readline.readline("> ", true)

      store.transaction do |store|
        store["api_key"] = api_key
      end

      clear_lines 2
      puts "API key stored successfully"
    end

    private

    def api_key
      @_api_key = store.transaction(true) do |store|
        store["api_key"]
      end
    end

    def ensure_logged_in!
      return if api_key
      puts "You need to authenticate first using `devstats auth`"
      exit(1)
    end

    def clear_lines(count = 1)
      print "\r" + ("\e[A\e[K"*count)
    end

    def store
      PStore.new(File.expand_path("~/devstats.pstore"))
    end
  end
end
