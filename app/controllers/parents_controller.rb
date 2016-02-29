class ParentsController < ApplicationController
  
  get "/parents" do 
    
  end
  
  get "/parents/:id" do 
    @parent = Parent.find(params[:id])
    erb :"/parents/show"
  end
    
end