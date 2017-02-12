$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "scifinding/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "scifinding"
  s.version     = Scifinding::VERSION
  s.authors     = ["Pierre Tremouilhac"]
  s.email       = ["pierre.tremouilhac@gmx.de"]
  s.homepage    = "https://www.github.com/complat/scifinding"
  s.summary     = "Plugin for Chemotion ELN: Scifinder functionalities "
  s.description = "enhance the chemotion Elecronic Lab Notebook with search functions from Scifinder (Scifinder Api v: ) "
  s.license     = "MIT-license"

  s.files = Dir["{app,config,db,lib}/**/*", "", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">=  4.2.0"
  s.add_dependency 'oauth2', "1.2.0"
  s.add_dependency 'attr_encrypted' ,"3.0.1"
end
