# require "sinatra/partial"

class ApplicationController < Sinatra::Base 
  configure do 
    register Sinatra::ActiveRecordExtension
    set :session_secret, "my_application_secret"
    set :views, Proc.new { File.join(root, "../views/") }
  end

  
  get "/" do 
    erb :index
  end
    
end