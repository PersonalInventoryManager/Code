require 'rubygems'
require 'data_mapper'

DataMapper.setup(:default, "sqlite:///#{Dir.pwd}/testdm.db")

require '../attribute'
require '../category'
require '../item'

DataMapper.finalize

DataMapper.auto_upgrade!

def disp_all()
  if !Item.all.nil?
    Item.all.each {|a|
      ctn = ""
      if !a.category.nil?
        ctn = a.category.cname
      end
      printf("id:%d; upc:%d; name:%s; location:%s; notes:%s; date_added:%s; "+
        "date_modified:%s; category:%s\n", a.id, a.upc, a.iname, a.location,\
        a.notes, a.date_added, a.date_modified, ctn)
      if !a.itemAttributes.nil?
        printf("Attributes:\n")
        a.itemAttributes.each {|b|
          printf("id:%d; key:%s; value:%s\n", b.id, b.akey, b.avalue)
        }
      end
      printf("\n\n");
    }
  end
end

disp_all();

printf("=============================================\n\n\n")

cat = Category.first_or_create(:cname => "RAM")
cat.categoryAttributes.create(:akey => "size")

itm = Item.create(:upc => rand(5000), :iname => "RAM#{rand(1000)}", :location =>\
  "box #{rand(20)} in the basement", :date_added => DateTime::now,\
  :date_modified => DateTime::now)
cat.items << itm

itm.save
cat.save

itm.itemAttributes.create(:akey => "size", :avalue => "#{rand(100)} GB")

disp_all();