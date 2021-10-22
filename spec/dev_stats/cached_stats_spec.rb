# frozen_string_literal: true

require "tempfile"

RSpec.describe DevStats::CachedStats do
  # PStore.new(File.expand_path("~/devstats.pstore"))
  let(:db_file) { Tempfile.new }
  let(:store) { PStore.new(db_file) }

  after { db_file.unlink }
  subject { described_class.new(store) }

  it "returns cached stats when they are store" do
    subject.save(DevStats::Stats.new("bob", 0, 0, 0))

    cached = subject.fetch
    expect(cached.username).to eq("bob")
    expect(cached.reactions).to eq(0)
    expect(cached.comments).to eq(0)
    expect(cached.followers).to eq(0)
  end

  it "returns nil when cached stats arent found" do
    expect(subject.fetch).to be_nil
  end
end
