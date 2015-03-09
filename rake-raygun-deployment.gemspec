Gem::Specification.new do |gem|

  gem.name = "rake-raygun-deployment"
  gem.summary = "Rake Raygun Deployment"
  gem.description = "A rake task to notify Raygun.io of a deployment"
  gem.homepage = "http://github.com/MindscapeHQ/rake-raygun-deployment"
  gem.authors = ["Jamie Penney", "Raygun.io"]
  gem.email = "hello@raygun.io"
  gem.license = "MIT"

  gem.version = File.read "VERSION"
  gem.platform = Gem::Platform::RUBY

  gem.files = Dir["{lib}/**/*.rb", "README.md", "LICENSE", "VERSION"]
  gem.require_path = "lib"

end