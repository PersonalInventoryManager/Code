class PersonalInventoryManager
  get '/add' do
    haml :add
  end

  post '/submit/add' do
    # do params parsing
    # insert a new item
    success = Item.create(*params)

    if success
      if params[:redirect].nil?
        return {:success => true}.to_json
      else
        redirect params[:redirect]
      end
    else
      redirect '/add'
    end
  end
end
