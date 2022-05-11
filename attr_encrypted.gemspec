require_relative 'lib/attr_encrypted/version'
require 'date'

Gem::Specification.new do |s|
  s.name    = 'attr_encrypted'
  s.version = AttrEncrypted::Version.string
  s.date    = Date.today

  s.summary     = 'Encrypt and decrypt attributes'
  s.description = 'Generates attr_accessors that encrypt and decrypt attributes transparently'

  s.authors   = ['Sean Huber', 'S. Brent Faulkner', 'William Monk', 'Stephen Aghaulor']
  s.email    = ['seah@shuber.io', 'sbfaulkner@gmail.com', 'billy.monk@gmail.com', 'saghaulor@gmail.com']
  s.homepage = 'http://github.com/attr-encrypted/attr_encrypted'
  s.license = 'MIT'

  s.rdoc_options = ['--line-numbers', '--inline-source', '--main', 'README.rdoc']
  s.files       = Dir["lib/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.required_ruby_version = '>= 2.7.0'
  s.add_dependency('encryptor', ['~> 3.0.0'])
  # support for testing with specific active record version
  activerecord_version = '>= 6.0.0'
  s.add_dependency 'net-smtp'
  s.add_development_dependency('activerecord', activerecord_version)
  s.add_development_dependency('actionpack', activerecord_version)
  s.add_development_dependency('rake')
  s.add_development_dependency('minitest')
  if defined?(RUBY_ENGINE) && RUBY_ENGINE.to_sym == :jruby
    s.add_development_dependency('activerecord-jdbcsqlite3-adapter')
    s.add_development_dependency('jdbc-sqlite3', '< 3.8.7') # 3.8.7 is nice and broke
  else
    s.add_development_dependency('sqlite3')
  end
  s.add_development_dependency('simplecov')
  s.add_development_dependency('appraisal')

  s.post_install_message = "\n\n\nWARNING: Several insecure default options and features were deprecated in attr_encrypted v2.0.0.\n
Additionally, there was a bug in Encryptor v2.0.0 that insecurely encrypted data when using an AES-*-GCM algorithm.\n
This bug was fixed but introduced breaking changes between v2.x and v3.x.\n
Please see the README for more information regarding upgrading to attr_encrypted v3.0.0.\n\n\n"

end
