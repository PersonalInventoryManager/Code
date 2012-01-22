require 'rubygems'
require 'data_mapper'

# This is to avoid path issues for requiring local files
$LOAD_PATH << File.dirname(__FILE__)

require 'debug'

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
  def self.setup(db_name)
    DataMapper.setup(:default, db_name)
    require 'attribute'
    require 'category'
    require 'item'
    DataMapper.finalize
    DataMapper.auto_upgrade!
  end
  
  def self.add_category(cname = nil)
    cn = cname
    if cn.nil? or cn.eq("")
      printd(2, "Category name empty or nil, using 'Uncategorized'")
      cn = "Uncategorized"
    end
    Category.first_or_create(:cname => cn)
  end
  
  def self.add_item(upc, iname, location = nil, notes = nil, date_added =\
    DateTime.now, category = nil)
    itm = Item.get(:upc => upc)
    if itm and not itm.nil?
      printd(1, "Item with upc #{upc} already exists!")
      return nil
    end
    itm = Item.new(:upc => upc, :iname => iname, :location => location,\
      :notes => notes, :date_added => date_added, :date_modified => date_added)
    cat = self.add_category(category);
    cat.items << itm
    if not itm.save
      itm.errors.each {|e|
        printd(1, e)
      }
    end
    if not cat.save
      cat.errors.each {|e|
        printd(1, e)
      }
    end
    return itm
  end
end