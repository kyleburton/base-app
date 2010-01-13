#!/usr/bin/env ruby
$:.push( File.dirname(__FILE__) + '/../lib' )
require 'base_app'

class TestApp < BaseApp
  def run
    puts "In the run"
  end
end

TestApp.main
