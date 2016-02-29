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
  
  get "/signup" do 
    erb :signup
  end
  
  post "/signup" do 
    "#{params}"
    error_message = "Something went wrong. "
    @user = User.new
    if params[:username].match(/\A[a-zA-Z0-9]+\z/)
      @user.username = params[:username]
    elsif params[:username] == ""
      error_message += "You must enter a username. "
    else
      error_message += "Username should contain only alphanumeric characters. "
    end
    if params[:password].length > 5
      @user.password = params[:password]
    else
      error_message += "Passwords must be at least 6 characters long. "
    end
    if params[:role] == "student"
      @user.role = Role.find_or_create_by(name: "student")
    elsif params[:role] == "parent" 
      @user.role = Role.find_or_create_by(name: "parent")
    elsif params[:role].nil?
      error_message += "Are you a Student or a Parent? "
    else
      error_message += "Are you a Student or a Parent? "
    end
    if @user.save
      redirect "/login"
    else
      erb :signup, locals: { message: error_message }
    end
  end
  
  get "/login" do 
    erb :login
  end
  
  
    
end