# require "sinatra/partial"

class ApplicationController < Sinatra::Base 
  configure do 
    enable :sessions
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
  
  post "/login" do 
    error_message = ""
    # finds the user by username or email address
    
    if params[:username] == "" || params[:password] == ""
      error_message = "You must enter a username and a password. "
    end
    if !User.find_by(username: params[:username]).nil?
      @user = User.find_by(username: params[:username])
    else
      error_message += "The given username and password do not match"
      erb :login, locals: { message: error_message }
    end
    
    if !@user.nil? && @user.authenticate(params[:password])
      session[:id] = @user.id
      if @user.role == Role.find_by(name: "teacher")
        @teacher = Teacher.find_by(user_id: @user.id)
        redirect "/teachers/#{@teacher.id}"
      end
      if @user.role.name == "student"
        @student = Student.find_by(user_id: @user.id)
        redirect "/students/#{@student.id}"
      end
      if @user.role.name == "parent"
        @parent = Parent.find_by(user_id: @user.id)
        redirect "/parents/#{@parent.id}"
      end
      if @user.role.name == "supreme leader"
        redirect "/admin"
      end
    else
      error_message += "The given username and password do not match."
      erb :login, locals: { message: error_message }
    end
    
  end
  
  post "/logout" do 
    session.clear
    redirect "/"
  end
  
  helpers do 
    def load_times
      @times = {0 => "12 AM"}.merge!(1.upto(11).collect { |n| {n => "#{n} AM" } }.reduce(Hash.new, :merge)).merge!({12 => "12 PM"}).merge!(1.upto(11).collect { |n| {n + 12 => "#{n} PM"} }.reduce(Hash.new, :merge))
    end
    
    def logged_in?
      !!session[:id]
    end
    
    def current_user
      User.find(session[:id])
    end
    
    def is_admin?
      current_user.role.name == "supreme leader"
    end
    
    def is_teacher?
      current_user.role.name == "teacher"
    end
    
    def is_parent?
      current_user.role.name == "parent"
    end
    
    def is_student?
      current_user.role.name == "student"
    end
    
    def current_teacher 
      Teacher.find_by(user_id: current_user.id)
    end
    
    def current_parent
      Parent.find_by(user_id: current_user.id)
    end
    
    def current_student
      Student.find_by(user_id: current_user.id)
    end
    
  end
  
  
    
end