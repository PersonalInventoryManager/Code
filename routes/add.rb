class PersonalInventoryManager
  get '/add' do
    haml :add
  end

  post '/submit/add' do
    # do params parsing
    # insert a new item
    
    success = true

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
