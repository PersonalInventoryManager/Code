require 'rubygems'
require 'data_mapper'

class ItemAttribute
  include DataMapper::Resource
  
  property :id,      Serial
  property :akey,     String,   :required => true
  property :avalue,   String,   :required => true
  
  belongs_to :item,             :required => false
  
end

class CategoryAttribute
  include DataMapper::Resource
  
  property :id,  Serial
  property :akey, String,   :required => true
  
  belongs_to :category,     :required => false
  
end