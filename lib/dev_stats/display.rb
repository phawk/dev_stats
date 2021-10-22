# frozen_string_literal: true
require "terminal-table"

module DevStats
  class Display
    def render(stats)
      headings = %w[Followers Reactions Comments]
      rows = [[stats.followers, stats.reactions, stats.comments]]
      Terminal::Table.new(title: "@#{stats.username}’s dev.to stats", headings: headings, rows: rows).to_s
    end
  end
end
