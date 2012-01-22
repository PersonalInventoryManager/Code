require 'rubygems'

# This is to avoid path issues for requiring local files
$LOAD_PATH << File.dirname(__FILE__)

require 'data_manager'

DataManager.setup("sqlite::memory:")

describe DataManager, "#add_category" do
  it "Returns [category]'Uncategorized' for default category" do
    ct = DataManager.add_category()
    ct.cname.should eq('Uncategorized')
  end
  
  it "Returns [category]'Category x' when defined as such" do
    for i in (1..100)
      ct = DataManager.add_category('Category ' + i)
      ct.cname.should eq('Category ' + i)
    end
  end
  
  it "Returns [category]'Category x' even when already added" do
    ct = DataManager.add_category()
    ct.cname.should eq('Uncategorized')
    
    for i in (1..100)
      ct = DataManager.add_category('Category ' + i)
      ct.cname.should eq('Category ' + i)
    end
  end
end

describe DataManager, "#add_item" do
  it "Returns [itm] of default upc and iname" do
    for i in (1..100)
      itm = DataManager.add_item(i, "Item " + i)
      
      itm.upc.should eq(i)
      item.iname.should eq("Item " + i)
    end
  end
  
  it "Returns nil when adding an existing item" do
    for i in (1..100)
      itm = DataManager.add_item(i, "Item " + i)
      
      itm.upc.nil?.should be true
    end
  end
end
