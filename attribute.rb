include 'rubygems'
include 'data_mapper'

class ItemAttribute
  include DataMapper::Resource
  
  property id,      Serial
  property key,     String
  property value,   String
  
  belongs_to :item
  
end

class CategoryAttribute
  include DataMapper::Resource
  
  property id,  Serial
  property key, String
  
  belongs_to :category
  
end