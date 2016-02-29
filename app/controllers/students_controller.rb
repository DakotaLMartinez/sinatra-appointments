class StudentsController < ApplicationController
  get "/students" do 
    
  end
  
  get "/students/:id" do 
    @student = Student.find(params[:id])
    erb :"/students/show"
  end
end