require 'rubygems'
require 'data_mapper'
require 'attribute.rb'

class Category
  include DataMapper::Resource
  
  property :id,   Serial
  property :cname, String
  
  has n, :categoryAttributes
  has n, :items
  
end