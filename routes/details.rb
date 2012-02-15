class PersonalInventoryManager
  get '/details' do
    upc = params[:upc].to_i  
    @detail_item = Item.first(:upc => upc)

    haml :details
  end
end 
