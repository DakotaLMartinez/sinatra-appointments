class StudentsController < ApplicationController
  get "/students" do 
    logged_in_do? do
      has_permission?(is_admin? || is_teacher? || is_parent?) do
        @students = Student.all if is_admin?
        @students = current_teacher.students if is_teacher?
        @students = current_parent.students if is_parent?
        erb :"/students/index" if @students
      end
    end
  end
  
  get "/students/:id" do 
    logged_in_do? do
      id = params[:id].to_i
      has_permission?(is_student? && current_student.id == id || is_teacher? && current_teacher.students.include?(Student.find(id)) || is_admin?) do 
        @student = Student.find(params[:id])
        load_times
        erb :"/students/show"
      end
    end
  end
  
  get "/students/:id/:date" do 
    logged_in_do? do 
      id = params[:id].to_i
      has_permission?(is_student? && current_student.id == id || is_teacher? && current_teacher.students.include?(Student.find(id)) || is_admin?) do 
        @student = Student.find(params[:id])
        @date = DateTime.parse(params[:date])
        load_times
        erb :"/students/calendar"
      end
    end
  end

end

    