require 'rubygems'
require 'sinatra'
require 'haml'

get '/deeper' do
  "This is deeper Sinatra."
end

get '/' do
  haml :index
end
