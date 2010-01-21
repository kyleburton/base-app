ruby -wc lib/base_app.rb  || exit -1
rake clobber_package
rake package && gem install pkg/base_app-*.gem
