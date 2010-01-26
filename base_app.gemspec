PKG_VERSION = '1.0.3'
PKG_FILES = Dir['lib/**/*.rb',
                  'spec/**/*.rb']
 
$spec = Gem::Specification.new do |s|
  s.name = 'base_app'
  s.version = PKG_VERSION
  s.summary = "Base class for command line applications."
  s.description = <<EOS
Simplified command line applications with a base class handling options parsing and other life cycle management.
EOS
  
  s.files = PKG_FILES.to_a
 
  s.has_rdoc = false
  s.authors = ["Kyle Burton", "Trotter Cashion"]
  s.email = "kyle.burton@gmail.com"
  s.homepage = "http://asymmetrical-view.com"
end
 
