include 'rubygems'
include 'data_mapper'
include 'attribute.rb'

class Category
  include DataMapper::Resource
  
  property :id,   Serial
  property :name, String
  
  has n, :categoryattributes
  
  def add_attribute(key)
    @categoryattributes << CategoryAttribute.create(key)
  end
  
end