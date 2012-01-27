require 'rubygems'
require 'data_mapper'

# This is to avoid path issues for requiring local files
$LOAD_PATH << File.dirname(__FILE__)

require 'pim_debug'

=begin
  To use the DataManager class, place the following code at the top of your file

$LOAD_PATH << File.dirname(__FILE__)

require 'data_manager'


  The following line of code should be run once per runtime (on startup), not on
  each page load or method call

DataManager.setup('<database name>')

  '<database name>' should be 'sqlite::memory:' for a runtime-only database, or
  'sqlite:///<path>' where <path> is the path of the .db file that the data is
  stored in.  You can use 'sqlite:///#{Dir.pwd}/file.db' to put a database file
  named file.db in the directory of the file running the code.  It is probably
  best to use a local path like this, so that the database file is in the same
  area as the code, and so that you don't have to worry about what the file
  structure of the computer is.
  
  All methods of DataManager are static, so you should not be creating an
  instance of DataManager.
=end
class DataManager
=begin
    Sets up the DataMapper database
    
    DataManager.setup(db_name)
      db_name:String => The name of the database (see above) (required, non-nil,
                            non-empty)
=end
  def self.setup(db_name)
    if db_name.nil? or db_name == ""
      printd(1, "Database name cannot be nil or empty!")
      return false
    end
    printd(3, "Setting up database '#{db_name}'.")
    DataMapper.setup(:default, db_name)
    require 'attribute'
    require 'category'
    require 'item'
    DataMapper.finalize
    DataMapper.auto_upgrade!
  end
  
=begin
    Gets a category or creates a new one if it does not already exist
    NOTE: if it does not find the category, it will create a new one and return
          that.  If cname is not specified, it will use "Uncategorized" instead.
    
    DataManager.get_category([cname])
      cname:String => The name of the category (optional, default: nil)
=end
  def self.get_category(cname = nil)
    cn = cname
    if cn.nil? or cn == ""
      printd(2, "Category name empty or nil, using 'Uncategorized'")
      cn = "Uncategorized"
    end
    printd(3, "Creating or retrieving category '#{cn}'.")
    return Category.first_or_create(:cname => cn)
  end
  
=begin
    Adds an item to the database using the given field values
    
    DataManager.add_item(upc, iname [, location [, notes [, date_added]]])
      upc:Integer => The UPC of the item (required, non-nil, unique)
      iname:String => The name of the item (required, not-nil, non-empty)
      location:String => The location of the item (optional, default: nil)
      notes:String => Any notes about the item (optional, default: nil)
      date_added:DateTime => The DateTime of when the item was added
                                  (optional, default: DateTime.now)
      category:String => The name of the category this item is in (optional,
                              (default: nil)
=end
  def self.add_item(upc, iname, location = nil, notes = nil, date_added =\
    DateTime.now, category = nil)
    if Item.count(:upc => upc) > 0
      printd(1, "Item with upc #{upc} already exists!")
      return nil
    end
    printd(3, "Creating item with upc #{upc}.")
    itm = Item.new(:upc => upc, :iname => iname, :location => location,\
      :notes => notes, :date_added => date_added, :date_modified => date_added)
    cat = self.get_category(category);
    cat.items << itm
    if not itm.save
      printd(1, "Item did not save!")
      itm.errors.each {|e|
        printd(1, e)
      }
      return nil
    end
    if not cat.save
      printd(1, "Category did not save!")
      cat.errors.each {|e|
        printd(1, e)
      }
      return nil
    end
    return itm
  end
  
=begin
    Gets the item with the specified UPC from the database
    
    DataManager.get_item(upc)
      upc:Integer => The UPC of the item (required, non-nil)  
=end
  def self.get_item(upc)
    if upc.nil?
      printd(1, "upc cannot be nil")
      return nil
    end
    printd(3, "Retrieving item with upc #{upc}")
    if Item.count(:upc => upc) <= 0
      printd(2, "Item with upc #{upc} not found!  Returning nil.")
      return nil
    end
    itm = Item.first(:upc => upc)
    return itm
  end
  
=begin
    Updates the value of the specified field of the specified item
    
    DataManager.update_item(upc, field_name, new_field_value)
      upc:Integer => The UPC of the item (required, non-nil)
      field_name:Symbol => The name of the field (such as :upc) to update
                                (required, not-nil, non-empty, valid field)
      new_field_value => The new value of the field (required; type and
                              constraints depend on what field)
=end
  def self.update_item(upc, field_name, new_field_value)
    itm = self.get_item(upc)
    if itm.nil?
      printd(1, "Could not get item!")
      return nil
    end
    if field_name.nil?
      printd(1, "Field name cannot be nil")
      return nil
    end
    if not itm.respond_to?(field_name)
      printd(1, "Invalid field name!")
      return nil
    end
    if not itm.update(field_name => new_field_value)
      printd(1, "Item did not update!")
      itm.errors.each {|e|
        printd(1, e)
      }
      return nil
    end
    return itm
  end
  
=begin
    Adds an attribute with the specified key to the specified category
    
    DataManager.add_attribute_to_category(akey [, cname])
      akey:String => The key of the attribute (required, non-nil, non-empty)
      cname:String => The name of the category to add the item to (optional,
                          default: nil)
=end
  def self.add_attribute_to_category(akey, cname = nil)
    if akey.nil? or akey == ""
      printd(1, "Category attribute key cannot be nil or empty!")
      return nil;
    end
    
    cat = self.get_category(cname)
    printd(3, "Creating category attribute '#{akey}' on category #{cat.cname}.")
    
    if cat.categoryAttributes.count(:akey => akey) > 0
      printd(3,
        "Attribute '#{akey}' already exists in category '#{cat.cname}'.")
      atr = cat.categoryAttributes.first(:akey => akey)
      return atr
    end
    
    atr = CategoryAttribute.new(:akey => akey)
    cat.categoryAttributes << atr
    
    if not atr.save
      printd(1, "CategoryAttribute did not save!")
      atr.errors.each {|e|
        printd(1, e)
      }
      return nil
    end
    
    if not cat.save
      printd(1, "Category did not save!")
      cat.errors.each {|e|
        printd(1, e)
      }
      return nil
    end
    
    return atr
  end
  
=begin
    Sets the item attribute to the specified value
    NOTE: This method will also add the attribute key to the item's category
          if the category does not already have that attribute key
    NOTE: If the attribute value is ommitted, nil, or empty, it will delete the
          attribute from the item
    
    DataManager.set_item_attribute(upc, akey [, avalue])
      upc:Integer => The UPC of the item to add the attribute to (required,
                          non-nil)
      akey:String => The key of the attrbute (required, non-nil, non-empty)
      avalue:String => The value of the attribute (optional, default:nil)
=end
  def self.set_item_attribute(upc, akey, avalue = nil)
    if upc.nil?
      printd(1, "upc cannot be nil")
      return nil
    end
    
    if akey.nil? or akey == ""
      printd(1, "Item attribute key cannot be nil or empty!")
      return nil
    end
    
    if avalue.nil? or avalue == ""
      printd(3, "Item attribute value nil or empty. Deleting from database.")
      return self.remove_item_attribute(upc, akey)
    end
    
    itm = self.get_item(upc)
    
    if itm.nil?
      printd(1, "Could not find item!")
      return nil
    end
    
    atr = self.get_item_attribute(upc, akey, 3)
    
    if atr.nil?
      printd(3,
      "Item with upc #{upc} does not have a value for the attribute '#{akey}'!"\
      "  Creating the attribute using value '#{avalue}'.  Also creating the "\
      "attribute in the item's category if it does not already exist.")
      cname = self.get_item(upc).category.cname
      self.add_attribute_to_category(akey, cname)
      atr = ItemAttribute.new(:akey => akey, :avalue => avalue)
      itm.itemAttributes << atr
      
      if not atr.save
        printd(1, "ItemAttribute did not save!")
        atr.errors.each {|e|
          printd(1, e)
        }
        return nil
      end
      
      if not itm.save
        printd(1, "Item did not save!")
        itm.errors.each {|e|
          printd(1, e)
        }
        return nil
      end
      
      return atr
    end
    
    printd(3, "Setting value of attribute '#{akey}' from item with upc #{upc}."\
      "to '#{avalue}'.")
    atr.avalue = avalue
    
    if not atr.save
      printd(1, "ItemAttribute did not save!")
      atr.errors.each {|e|
        printd(1, e)
      }
      
      return nil
    end
    
    return atr
  end
  
=begin
    Gets the attribute with the specified key belonging to the item with the
    specified upc
    NOTE: The missing_debug_level parameter should not be used unless you want
          to make the message about the attribute key not being on the item
          be something other than an error message.  It is included so that the
          set_item_attribute method can try to get the item attribute and
          create it if it does not exist, without displaying it as an error
    
    DataManager.get_item_attribute(upc, akey [, missing_debug_level])
      upc:Integer => The UPC of the item to get the attribute of (required,
                          non-nil)
      akey:String => The key of the attribute to get (required, non-nil,
                          non-empty)
      missing_debug_level:Integer => The debug level of the missing attribute
                                          message (see note above) (optional,
                                          default: 1)
=end
  def self.get_item_attribute(upc, akey, missing_debug_level = 1)
    if upc.nil?
      printd(1, "upc cannot be nil")
      return nil
    end
    
    if akey.nil? or akey == ""
      printd(1, "Item attribute key cannot be nil or empty!")
      return nil
    end
    
    itm = self.get_item(upc)
    
    if itm.nil?
      printd(1, "Could not find item!")
      return nil
    end
    
    if itm.itemAttributes.count(:akey => akey) <= 0
      printd(missing_debug_level,
      "Item with upc #{upc} does not have a value for the attribute '#{akey}'!")
      return nil
    end
    
    printd(3, "Retrieving attribute '#{akey}' from item with upc #{upc}.")
    atr = itm.itemAttributes.first(:akey => akey)
    
    return atr
  end
  
=begin
    Removes the specified attribute from the item with the specified upc
    NOTE: This is automatically called if you call set_item_attribute with an
          omitted, nil, or empty attribute value
    
    DataManager.remove_item_attribute(upc, akey)
      upc:Integer => The UPC of the item to remove the attribute from (required,
                          non-nil)
      akey:String => The key of the attribute to remove (required, non-nil,
                          non-empty)
=end
  def self.remove_item_attribute(upc, akey)
    if upc.nil?
      printd(1, "upc cannot be nil")
      return false
    end
    if akey.nil? or akey == ""
      printd(1, "Item attribute key cannot be nil or empty!")
      return false
    end
    itm = self.get_item(upc)
    if itm.nil?
      printd(1, "Could not find item!")
      return false
    end
    if itm.itemAttributes.count(:akey => akey) <= 0
      printd(1,
      "Item with upc #{upc} does not have a value for the attribute '#{akey}'!")
      return false
    end
    printd(3, "Deleting attribute '#{akey}' from item with upc #{upc}.")
    atr = itm.itemAttributes.first(:akey => akey)
    rval = atr.destroy
    if not itm.save
      itm.errors.each {|e|
        printd(1, e)
      }
      return false
    end
    itm.itemAttributes.refresh_all
    Attributes.refresh_all
    return rval
  end
end