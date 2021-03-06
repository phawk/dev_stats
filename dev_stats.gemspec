# frozen_string_literal: true

require_relative "lib/dev_stats/version"

Gem::Specification.new do |spec|
  spec.name          = "dev_stats"
  spec.version       = DevStats::VERSION
  spec.authors       = ["Pete Hawkins"]
  spec.email         = ["petey@hey.com"]

  spec.summary       = "CLI to show common stats for your dev.to account"
  spec.description   = "CLI to show followers, post views and likes for your dev.to account"
  spec.homepage      = "https://github.com/phawk/dev_stats"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/phawk/dev_stats/commits/main"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = %w[devstats]
  spec.require_paths = ["lib"]

  spec.add_dependency "terminal-table", "~> 3.0.2"
  spec.add_dependency "thor"
end
