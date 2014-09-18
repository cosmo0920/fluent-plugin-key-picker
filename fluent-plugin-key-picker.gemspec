Gem::Specification.new do |gem|
  gem.name          = 'fluent-plugin-key-picker'
  gem.version       = '0.0.2'
  gem.authors       = ['Carlos Donderis']
  gem.email         = ['cdonderis@gmail.com']
  gem.homepage      = 'http://github.com/cads/fluent-plugin-key-picker'
  gem.description   = %q{Fluentd plugin for picking desired keys.}
  gem.summary       = %q{Fluentd plugin for picking desired keys.}

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'fluentd'
  gem.add_runtime_dependency     'fluentd'
end
