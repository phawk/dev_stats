# frozen_string_literal: true

module DevStats
  class CachedStats
    attr_reader :store

    def initialize(store)
      @store = store
    end

    def save(stats)
      store.transaction do |str|
        str["cached_stats"] = stats.to_h
      end
    end

    def fetch
      @store.transaction do |store|
        if (cached = store["cached_stats"])
          Stats.new(*store["cached_stats"].values)
        end
      end
    end
  end
end
