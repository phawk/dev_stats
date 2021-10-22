# frozen_string_literal: true

RSpec.describe DevStats::Display do
  let(:stats) { DevStats::Stats.new("phawk", 114, 13, 32) }

  it "displays stats in a table" do
    expect(subject.render(stats) + "\n").to eq(<<~DISPLAY
      +----------------------------------+
      |      @phawk’s dev.to stats       |
      +-----------+-----------+----------+
      | Followers | Reactions | Comments |
      +-----------+-----------+----------+
      | 32        | 114       | 13       |
      +-----------+-----------+----------+
    DISPLAY
    )
  end

  it "keeps count of rendered_lines" do
    expect(subject.rendered_lines).to eq (0)
    subject.render(stats)
    expect(subject.rendered_lines).to eq (7)
  end
end
