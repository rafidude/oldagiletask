require 'sinatra'
require 'slim'
require 'json'
require 'mongo'
require "sinatra/reloader" if development?

class DataModel
  def self.save(doc)
    db = Mongo::Connection.new.db("testdb1")
    coll = db["docs"]
    coll.insert(doc)
  end
end

class AgileTaskApp < Sinatra::Base
  enable  :sessions, :logging
  configure :development do
    register Sinatra::Reloader
  end
  helpers do
    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['admin', 'admin']
    end
  end

  get '/' do
    slim :index
  end

  get '/protected' do
    protected!
    "Welcome authenticated client"
  end
  
  get '/example.json' do
    content_type :json
    { :key1 => 'value1', :key2 => 'value2' }.to_json
  end
  
  post '/postit/?' do
    jdata = params[:data]
    begin
      doc = JSON.parse(jdata)
      DataModel.save(doc)
    rescue
      puts "unable to parse JSON"
    end
    puts jdata
  end
  
  get '/test' do
    session['counter'] ||= 0
    session['counter'] += 1
    "You've hit this page #{session['counter']} times!"
  end
  
  get '/hello' do
    if params[:name]
      "Hello #{params[:name]}" 
    else
      "Hello World"
    end
  end
end