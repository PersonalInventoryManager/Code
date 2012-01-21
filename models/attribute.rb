require 'rubygems'
require 'data_mapper'

class ItemAttribute
  include DataMapper::Resource
  
  property :id,      Serial
  property :akey,     String
  property :avalue,   String
  
  belongs_to :item
    
  
end

class CategoryAttribute
  include DataMapper::Resource
  
  property :id,  Serial
  property :akey, String
  
  belongs_to :category
  
end