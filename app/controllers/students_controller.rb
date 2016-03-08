class StudentsController < ApplicationController
  get "/students" do 
    logged_in_do? do
      has_permission?(is_admin? || is_teacher? || is_parent?) do
        @students = Student.all if is_admin?
        @students = current_teacher.students if is_teacher?
        @students = current_parent.students if is_parent?
        @students = [current_student] if is_student?
        erb :"/students/index" if @students
      end
    end
  end
  
  get "/students/new" do
    logged_in_do? do
      has_permission?(is_admin? || is_parent? || is_student? && current_student.nil?) do
        @teachers = Teacher.all
        erb :"/students/new"
      end
    end
  end
  
  get "/students/:id" do 
    logged_in_do? do
      @student = Student.find(params[:id])
      has_permission?(is_student? && current_student == @student || is_teacher? && current_teacher.students.include?(@student) || is_parent? && current_parent.students.include?(@student) || is_admin?) do 
        @teachers = Teacher.all
        load_times
        erb :"/students/show"
      end
    end
  end
  
  post "/students" do 
    @student = Student.create(params[:student])
    if @student.errors.count == 0
      @student.user_id = session[:id] if is_student? || is_parent?
      @student.save
      @teachers = Teacher.all
      erb :"/students/show"
    else
      erb :"/students/new"
    end
    
  end
  
  get "/students/:id/edit" do 
    logged_in_do? do
      @student = Student.find(params[:id])
      has_permission?(is_student && current_student == @student || is_teacher? && current_teacher.students.include?(@student) || is_parent? && current_parent.students.include?(@student) || is_admin? ) do
        erb :"/students/edit"
      end
    end
  end
  
  post "/students/:id" do 
    logged_in_do? do 
      @student = Student.find(params[:id])
      has_permission(is_student? && current_student == @student || is_teacher? && current_teacher.students.include?(@student) || is_parent? && current_parent.students.include?(@student) || is_admin?) do 
        @student.update(params[:student])
        if @student.errors.count == 0
          erb :"/students/show"
        else
          erb :"/students/edit"
        end
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

    