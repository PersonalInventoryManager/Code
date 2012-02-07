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
    printd(3, "Creating or retrieving category '#{cat}'.")
    cato = Category.first_or_create(:cname => cat)
    if Item.count(:upc => upc) > 0
      printd(1, "Item with upc #{upc} already exists!")
      success = false
    end
    
    if success
      printd(3, "Creating item with upc #{upc}.")
      itm = Item.new(:upc => upc, :iname => nme, :location => loc,\
        :notes => notes, :date_added => DateTime.now, :date_modified => DateTime.now,
        :category => cato)
      if not itm.save
        printd(1, "Item did not save!")
        itm.errors.each {|e|
          printd(1, e)
        }
        success = false
      end
    end
    
    # add attributes
    if success
      param_index = 0
      while not params["key#{param_index}".to_sym].nil? and params["key#{param_index}".to_sym] != ""\
        and not params["val#{param_index}".to_sym].nil? and params["val#{param_index}".to_sym] != ""
        ca = cato.categoryAttributes.first_or_create(:akey => params["key#{param_index}".to_sym])
        ia = itm.itemAttributes.new(:akey => params["key#{param_index}".to_sym], :avalue => params["val#{param_index}".to_sym] )
        
        if not ia.save
          printd(1, "Item attribute did not save.")
          ia.errors.each {|e|
            printd(1, e)
          }
          success = false
        end
        
        param_index += 1
      end
    end

    if success
      if params[:redirect].nil?
        return {:success => true}.to_json
      else
        redirect params[:redirect]
      end
    else
      if not itm.nil?
        itm.destroy
      end
      if params[:redirect].nil?
        return {:success => false}.to_json
      else
        redirect '/add'
      end
    end
  end
end
