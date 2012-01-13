require 'rubygems'
require 'data_mapper'
require 'attribute.rb'

class Category
  include DataMapper::Resource
  
  property :id,   Serial
  property :cname, String
  
  has n, :categoryAttributes
  belongs_to :item
  
  def add_attribute(key)
    if !@categoryAttributes.nil? and @categoryAttributes.get(:akey => key).nil?
      @categoryAttributes.create(:akey => key)
    end
  end
  
end