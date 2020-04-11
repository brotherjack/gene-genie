require 'lib/gene_genie/version'

Gem::Specification.new do |spec|
  spec.name          = 'gene_genie'
  spec.version       = GeneGenie::VERSION
  spec.authors       = ['Thomas Adriaan Hellinger']
  spec.email         = ['brotherjack1877@gmail.com']

  spec.summary       = 'A program for developing genetic algorithims'
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = 'https://github.com/brotherjack/gene-genie'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/brotherjack/gene-genie'
  spec.metadata['changelog_uri'] = 'https://github.com/brotherjack/gene-genie/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
