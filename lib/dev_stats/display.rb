# frozen_string_literal: true
require "terminal-table"

module DevStats
  class Display
    attr_reader :rendered_lines

    def initialize
      @rendered_lines = 0
    end

    def render(stats)
      headings = %w[Followers Reactions Comments]
      rows = [[stats.followers, stats.reactions, stats.comments]]
      output = Terminal::Table.new(title: "@#{stats.username}’s dev.to stats", headings: headings, rows: rows).to_s
      @rendered_lines += output.lines.size
      output
    end
  end
end
