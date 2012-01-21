require 'rubygems'
require 'data_mapper'
require 'attribute.rb'
require 'category.rb'

class Item
  include DataMapper::Resource
  
  property :id,             Serial
  property :upc,            Integer
  property :iname,          String
  property :location,       String
  property :notes,          String
  property :date_added,     DateTime
  property :date_modified,  DateTime
  
  has n, :itemAttributes
  belongs_to :category, :required => false
  
end