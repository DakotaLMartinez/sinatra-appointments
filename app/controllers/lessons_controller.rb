class LessonsController < ApplicationController
  
  ######## Admin Routes ########
  get "/lessons" do 
    if logged_in?
      if is_admin? 
        @lessons = Lesson.all
        erb :"lessons/index"
      elsif is_teacher?
        @lessons = current_teacher.lessons
        erb :"lessons/index"
      elsif is_student?
        @lessons = current_student.lessons
        erb :"lessons/index"
      else
        
      end
    else
      erb :login, locals: { message: "You must be logged in to view this page" }
    end
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
    @teacher = Teacher.find(params[:id])
    @lessons = @teacher.lessons
    erb :"lessons/index"
  end
  
  get "/lessons/:id/edit" do
    if logged_in?
      @lesson = Lesson.find(params[:id])
      @teacher = @lesson.teacher
      if current_user.role.name == "supreme leader" || current_user.role.name == "teacher" && @teacher.lessons.include?(@lesson)
        erb :"/lessons/edit"
      else
        erb :failure, locals: { message: "You don't have permission to edit this lesson" }
      end
    else
      erb :login, locals: { message: "You must be logged in to view that page" }
    end
    
  end
  
  ######## Parent Routes ########

    
end