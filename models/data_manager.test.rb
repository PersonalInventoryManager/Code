require 'rubygems'

# This is to avoid path issues for requiring local files
$LOAD_PATH << File.dirname(__FILE__)

require 'data_manager'

$debug_level = 0
DataManager.setup("sqlite::memory:")

=begin
describe DataManager, "#get_category" do
  it "Returns [category]'Uncategorized' for default category" do
    ct = DataManager.get_category()
    ct.cname.should eq('Uncategorized')
  end
  
  it "Returns [category]'Category x' when defined as such" do
    for i in (1..100)
      ct = DataManager.get_category("Category #{i}")
      ct.cname.should eq("Category #{i}")
    end
  end
  
  it "Returns [category]'Category x' even when already added" do
    ct = DataManager.get_category()
    ct.cname.should eq('Uncategorized')
    
    for i in (1..100)
      ct = DataManager.get_category("Category #{i}")
      ct.cname.should eq("Category #{i}")
    end
  end
end

describe DataManager, "#add_item" do
  it "Returns [itm] of default upc and iname" do
    for i in (1..100)
      itm = DataManager.add_item(i, "Item #{i}")
      
      itm.upc.should eq(i)
      itm.iname.should eq("Item #{i}")
    end
  end
  
  it "Returns nil when adding an existing item" do
    for i in (1..100)
      itm = DataManager.add_item(i, "Item #{i}")
      
      itm.nil?.should be_true
    end
  end
end

describe DataManager, "#get_item" do
  it "Returns nil when upc is nil" do
    nil_upc = DataManager.get_item(nil)
    nil_upc.nil?.should be_true
  end
  
  it "Returns items that already exist" do
    for i in (1..100)
      itm = DataManager.get_item(i)
      
      itm.upc.should eq(i)
      itm.iname.should eq("Item #{i}")
    end
  end
  
  it "Returns nil when item is nonexistant" do
    nil_itm = DataManager.get_item(101)
    itm.nil?.should be_true
  end
end

describe DataManager, "#update_item" do
  it "Returns the item with an updated upc" do
  end
  
  it "Returns the item with an updated"
end

describe DataManager, "#add_attribute_to_category" do

end

describe DataManager, "#set_item_attribute" do

end

describe DataManager, "#get_item_attribute" do

end

describe DataManager, "#remove_item_attribute" do

end
=end 
