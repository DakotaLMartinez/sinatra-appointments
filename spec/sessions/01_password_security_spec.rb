require "spec_helper"

describe ApplicationController do 

  describe "GET '/'" do 
    it 'returns a 200 status code' do 
      get '/'
      expect(last_response.status).to eq(200)
    end

    it 'returns a page that contains a login and signup links' do 
      get '/'
      expect(last_response.body).to include('<a href="/signup">Sign Up</a>')
      expect(last_response.body).to include('<a href="/login">Log In</a> to continue')
    end
  end

  describe "GET '/signup'" do 
    it 'returns a 200 status code' do 
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'returns contains a form to login' do 
      visit '/signup'
      expect(page).to have_selector("form")
      expect(page).to have_field(:username)
      expect(page).to have_field(:password)
    end
  end

  describe "POST '/signup'" do 
    it 'returns a 200 status code' do 
      visit '/signup'
      fill_in "username", :with => "student1"
      fill_in "password", :with => "test"
      
      click_button "Sign Up"
      expect(page.current_path).to eq('/login')
      expect(page.status_code).to eq(200)
    end
    it "displays the failure page if no username is given" do
      post '/signup', {"username" => "", "password" => "hello"}
      follow_redirect!
      expect(last_response.body).to include('Error')
    end
    it "displays the failure page if no password is given" do
      post '/signup', {"username" => "hello", "password" => ""}
      follow_redirect!
      expect(last_response.body).to include('Error')
    end
  end

  describe "GET '/login'" do 
    it 'returns a 200 status code' do 
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads a form to login' do 
      visit '/login'
      expect(page).to have_selector("form")
      expect(page).to have_field(:username)
      expect(page).to have_field(:password)
    end
  end

  describe "POST '/login'" do
    it "displays the failure page if no username is given" do
      post '/login', {"username" => "", "password" => "I<3Ruby"}
      follow_redirect!
      expect(last_response.body).to include('Error')
      expect(session[:id]).to be(nil)
    end

    it "displays the failure page if no password is given" do
      post '/login', {"username" => "avi", "password" => ""}
      follow_redirect!
      expect(last_response.body).to include('Error')
      expect(session[:id]).to be(nil)
    end

    it "displays the user's account page if username and password is given" do
      user = User.new(username: "avi", password: "I<3Ruby")
      user.save
      post '/login', {"username" => "avi", "password" => "I<3Ruby"}
      follow_redirect!
      expect(last_response.body).to include('Welcome')
      expect(last_response.body).to include('avi')
      expect(session[:id]).to_not be(nil)
    end
    it 'returns a 200 status code' do 
      user = User.create(:username => "student1", :password => "test")
      visit '/login'
      fill_in "username", :with => "student1"
      fill_in "password", :with => "test"
      
      click_button "Log In"
      expect(page.current_path).to eq('/success')
      expect(page.status_code).to eq(200)
    end
  end

  describe "GET '/success'" do 
    it 'displays the username' do 
      user = User.create(:username => "student1", :password => "test")
      visit '/login'
      fill_in "username", :with => "student1"
      fill_in "password", :with => "test"
      
      click_button "Log In"

      expect(page.body).to include(user.username)
    end
  end

  describe "GET '/failure'" do 
    it 'displays failure message' do 
      visit '/failure'

      expect(page.body).to include("Houston, We Have a Problem")
    end
  end

  describe "GET '/logout'" do 
    it 'clears the session hash and redirects to home page' do 
      user = User.create(:username => "student1", :password => "test")
      visit '/login'
      fill_in "username", :with => "student1"
      fill_in "password", :with => "test"
      click_button "Log In"
      get '/logout'
      expect(session.keys).to eq([])
      expect(session.values).to eq([])
      expect(last_response.location).to eq("http://example.org/")
    end
  end
end