class LessonsController < ApplicationController
  
  
  ######## Admin Routes ########
  get "/admin/lessons" do 
    @lessons = Lesson.all
    erb :"lessons/index"
  end
  
  get "/admin/lessons/:id" do
    @lesson = Lesson.find(params[:id])
    erb :"lessons/show"
  end
  
  get "/admin/lessons/:id/edit" do 
    @lesson = Lesson.find(params[:id])
    erb :"lessons/edit"
  end
  
  ######## Teacher Routes ########
  
  get "/teacher/:id/lessons" do 
    @teacher = Teacher.find_by(user_id: params[:id])
    @lessons = @teacher.lessons
    erb :"lessons/index"
  end
  
  ######## Parent Routes ########

    
end