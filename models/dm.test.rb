require 'rubygems'
require 'data_mapper'

# DataMapper.setup needs to be called before requiring the DataMapper classes
DataMapper.setup(:default, "sqlite::memory:")

# This is to avoid path issues for requiring local files
$LOAD_PATH << File.dirname(__FILE__)

require 'attribute'
require 'category'
require 'item'

DataMapper.finalize

DataMapper.auto_upgrade!

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
  it "returns 50 for updated upc" do
    itm.upc = 50
    itm.save
    itm.upc.should eq(50)
  end
end

describe Item, "#iname" do
  it "returns 'RAM 8' for default iname" do
    itm.iname.should eq("RAM 8")
  end
  it "returns 'RAM 16' for updated iname" do
    itm.iname = 'RAM 16'
    itm.save
    itm.iname.should eq('RAM 16')
  end
end

describe Item, "#location" do
  it "returns 'box 4 in the basement' for default location" do
    itm.location.should eq('box 4 in the basement')
  end
  it "returns 'box 10 in the basement' for updated location" do
    itm.location = 'box 10 in the basement'
    itm.save
    itm.location.should eq('box 10 in the basement')
  end
end

describe Item, "#notes" do
  it "returns nil for default notes" do
    itm.notes.should eq(nil)
  end
  it "returns 'foo' for updated upc" do
    itm.notes = 'foo'
    itm.save
    itm.notes.should eq('foo')
  end
end

describe Item, "#date_added" do
  it "returns noon at the new year (2012) for the default date added" do
    itm.date_added.should eq(dt)
  end
end

describe Item, "#date_modified" do
  it "returns noon at the new year (2012) for the default date modified" do
    itm.date_modified.should eq(dt)
  end
  it "returns 4:30 PM at the 25th of January of 2012 for the updated date modified" do
    itm.date_modified = dt2
    itm.save
    itm.date_modified.should eq(dt2)
  end
end
