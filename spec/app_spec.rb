require_relative 'test_helper'
require_relative '../lib/app'

set :environment, :test

describe "Website pages" do
  include Rack::Test::Methods

  def app() AgileTaskApp end
  
  it "should find the home page" do
    get '/'
    last_response.status.must_equal 200
    last_response.body.must_match /Hello AgileTask!/
  end
end