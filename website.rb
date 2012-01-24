require 'rubygems'
require 'sinatra'
require 'haml'

=begin
  Quick start:
    $ruby website.rb
    
  Open the browser and go to localhost:xxxx where xxxx is given in the terminal.
  Need to restart the website every time a change is made.
=end

get '/deeper' do
  "This is deeper Sinatra."
end

get '/' do
  haml :index
end
