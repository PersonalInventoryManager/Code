include 'rubygems'
include 'data_mapper'
include 'attribute.rb'
include 'category.rb'

class Item
  include DataMapper::Resource
  
  property :id,             Serial
  property :upc,            int
  property :name,           String
  property :location,       String
  property :notes,          String
  property :date_added,     DateTime
  property :date_modified,  DateTime
  
  has n, :itemattributes
  has 1, :category
  
  def add_attribute(key, value)
    @itemattributes << ItemAttribute.create(key, value)
  end
  
end