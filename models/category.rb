require 'rubygems'
require 'data_mapper'

class Category
  include DataMapper::Resource
  
  property :id,   Serial
  property :cname, String,  :required => true
  
  has n, :categoryAttributes
  has n, :items
  
end