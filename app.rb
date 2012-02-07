require 'sinatra/base'
require 'haml'
require 'sass'
require 'json'
require 'data_mapper'

Dir.glob('./models/*.rb').each { |f| require f }

class PersonalInventoryManager < Sinatra::Base
  configure do
    $debug_level = 2
    set :public_folder, File.dirname(__FILE__) + "/public"
    set :prefixed_redirects, true
    
    printd(3, "Setting up database 'database/pim_db.sqlite'.")
    DataMapper.setup(:default, "sqlite:database/pim_db.sqlite")
    DataMapper.auto_upgrade!
    DataMapper.finalize
    
    if Category.all.length == 0
      printd(3, "Adding default category ('Uncategorized').")
      cat = Category.create(:cname => "Uncategorized")
      cat.save
    end
  end
  
  run! if app_file == $0
end

Dir.glob('./routes/*.rb').each { |f| require f }
