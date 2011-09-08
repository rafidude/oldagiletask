require 'sinatra'
require File.join(File.dirname(__FILE__), 'lib/app.rb')

set :environment, :development

run AgileTaskApp
