require 'rubygems'
require 'data_mapper'

# DataMapper.setup needs to be called before requiring the DataMapper classes
DataMapper.setup(:default, "sqlite::memory:")

# This is to avoid path issues for requiring local files
$LOAD_PATH << File.dirname(__FILE__)

require 'attribute'
require 'category'
require 'item'

cat = Category.first_or_create(:cname => "RAM")
cat.categoryAttributes.create(:akey => "size")

dt = DateTime.new(2012, 1, 1, 12, 0, 0, 0)
dt2 = DateTime.new(2012, 1, 25, 16, 30, 0, 0)

# .create instead of .new to automateically store it in the database
itm = Item.create(:upc => 25, :iname => "RAM 8", :location =>\
  "box 4 in the basement", :date_added => dt,\
  :date_modified => dt)

cat.items << itm

itm.save
cat.save

describe Item, "#upc" do
  it "returns 25 for default upc" do
    itm.upc.should eq(25)
  end
end
