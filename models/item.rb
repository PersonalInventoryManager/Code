require 'rubygems'
require 'data_mapper'
require 'attribute.rb'
require 'category.rb'

class Item
  include DataMapper::Resource
  
  property :id,             Serial
  property :upc,            Integer,    :required => true,    :unique => true
  property :iname,          String,     :required => true
  property :location,       String
  property :notes,          String
  property :date_added,     DateTime,   :required => true
  property :date_modified,  DateTime,   :required => true
  
  has n, :itemAttributes
  belongs_to :category,                 :required => false
  
end