require 'rubygems'
require 'rake'
# require 'rake/gempackagetask'
require 'rubygems/package_task'
# require 'spec/rake/spectask'
load 'base_app.gemspec'

SPEC_FILES = FileList['spec/*_spec.rb']

task :default => :spec

# desc "Run all specs"
# Spec::Rake::SpecTask.new('spec') do |t|
#   t.spec_files = SPEC_FILES
# end

# desc "Run rcov"
# Spec::Rake::SpecTask.new('rcov') do |t|
#   t.spec_files = SPEC_FILES
#   t.rcov = true
#   t.rcov_opts = ['--exclude', 'spec']
# end

# Rake::GemPackageTask.new($spec) do |t|
#   t.need_tar = true
# end

Gem::PackageTask.new($spec) do |pt|
  pt.need_tar = true
end
