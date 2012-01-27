require 'rubygems'

# This is to avoid path issues for requiring local files
$LOAD_PATH << File.dirname(__FILE__)

require 'data_manager'

$debug_level = 0
DataManager.setup("sqlite::memory:")

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
    nil_itm.nil?.should be_true
  end
end

describe DataManager, "#update_item" do
  it "Returns nil when an item is nonexistant" do
    nil_itm = DataManager.update_item(101, :upc, 102)
    nil_itm.nil?.should be_true
  end
  
  it "Returns nil when field is nil" do
    nil_itm = DataManager.update_item(1, nil, 101)
    nil_itm.nil?.should be_true
  end
  
  it "Returns nil when field name is not a property of the item class" do
    nil_itm = DataManager.update_item(1, :invalid_field, 101)
    nil_itm.nil?.should be_true
  end
  
  it "Returns the item with an updated field, if valid" do
    for i in (1..100)
      itm = DataManager.update_item(i, :iname, "New name #{i}")

      itm.iname.should eq("New name #{i}")
    end
    
    for i in (1..100)
      itm = DataManager.update_item(i, :location, "Box #{i} in the basement")
      
      itm.location.should eq("Box #{i} in the basement")
    end
    
    for i in (1..100)
      itm = DataManager.update_item(i, :notes, "Note for item #{i}")
      
      itm.notes.should eq("Note for item #{i}")
    end
    
    for i in (1..100)
      itm = DataManager.update_item(i, :upc, 100 + i)
      
      itm.upc.should eq(100 + i)
    end
    
    for i in (1..100)
      itm = DataManager.get_item(i)
      itm.nil?.should be_true
      
      itm = DataManager.get_item(100 + i)
      itm.nil?.should be_false
      itm.upc.should eq(100 + i)
      
      itm = DataManager.update_item(100 + i, :upc, i)
      itm.upc.should eq(i)
      
      itm = DataManager.get_item(100 + i)
      itm.nil?.should be_true
    end
  end
end

describe DataManager, "#add_attribute_to_category" do
  it "Returns nil for a nil key or blank string" do
    atr = DataManager.add_attribute_to_category(nil)
    atr.nil?.should be_true
    
    atr = DataManager.add_attribute_to_category("")
    atr.nil?.should be_true
  end
  
  it "Returns the attribute assigned to a category" do
    atr = DataManager.add_attribute_to_category("test_category_attribute")
    
    atr.akey.should eq("test_category_attribute")
  end
end

describe DataManager, "#set_item_attribute" do
  it "Returns nil when the upc is nil or nonexistant" do
    atr = DataManager.set_item_attribute(nil, "test_item_attribute")
    atr.nil?.should be_true
    
    atr = DataManager.set_item_attribute(1001, "test_item_attribute")
    atr.nil?.should be_true
  end
  
  it "Returns nil if the item attribute is nil or empty" do
    atr = DataManager.set_item_attribute(1, nil)
    atr.nil?.should be_true
  
    atr = DataManager.set_item_attribute(1, "")
    atr.nil?.should be_true
  end

  it "Returns the attribute given valid upc, field, and value" do
    atr = DataManager.set_item_attribute(1, "test_item_attribute")
    
=begin not sure how to test an item's attribute
    itm = DataManager.get_item_attribute(1, "test_item_attribute")
    
    itm.nil?.should be_false
=end
  end
end
 
=begin same problem as above, how do i test this?
describe DataManager, "#get_item_attribute" do 
end
describe DataManager, "#remove_item_attribute" do
end
=end
