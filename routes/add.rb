class PersonalInventoryManager
  get '/add' do
    haml :add
  end

  post '/submit/add' do
    success = true
    
    # do params parsing
    nme = params[:nme]
    upc = params[:upc].to_i
    loc = params[:loc]
    cat = params[:cat]
    if cat.nil? or cat == ""
      printd(2, "Category name empty or nil, using 'Uncategorized'")
      cat = "Uncategorized"
    end
    notes = params[:notes]
    
    # insert a new item
    printd(3, "Creating or retrieving category '#{cn}'.")
    cato = Category.first_or_create(:cname => cat)
    if Item.count(:upc => upc) > 0
      printd(1, "Item with upc #{upc} already exists!")
      return nil
    end
    printd(3, "Creating item with upc #{upc}.")
    itm = Item.new(:upc => upc, :iname => iname, :location => location,\
      :notes => notes, :date_added => date_added, :date_modified => date_added,
      :category => cato)
    if not itm.save
      printd(1, "Item did not save!")
      itm.errors.each {|e|
        printd(1, e)
      }
      success = false
    end
    
    # add attributes
    

    if success
      if params[:redirect].nil?
        return {:success => true}.to_json
      else
        redirect params[:redirect]
      end
    else
      if params[:redirect].nil?
        return {:success => false}.to_json
      else
        redirect '/add'
      end
    end
  end
end
