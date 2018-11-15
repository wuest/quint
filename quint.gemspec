$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'quint/version'

Gem::Specification.new do |s|
  s.name = 'quint'
  s.version = Quint::VERSION

  s.authors     = ['Tina Wuest']
  s.email       = ['tina@wuest.me']
  s.homepage    = 'https://github.com/wuest/quint'
  s.description = 'Tools for introducing gradual typing concepts in ruby codebases'
  s.summary     = 'Gradual typing in ruby'
  s.license     = 'MIT'

  s.files         = `git ls-files lib`.split("\n")
  s.require_paths = ['lib']

  s.add_development_dependency 'rake',     '~> 10.0'
  s.add_development_dependency 'minitest', '~>  5.0'
end
