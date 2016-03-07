class TeachersController < ApplicationController 
  
  get "/teachers" do 
    @teachers = Teacher.all
    erb :"/teachers/index"
  end
  
  get "/teachers/:id" do 
    @teacher = Teacher.find(params[:id])
    logged_in_do? do
      if is_student?
        @students = [current_student]
        @lessons = current_student.lessons.select { |l| l.teacher_id == params[:id] }
      end
      if is_teacher?
        @students = current_teacher.students
        @lessons = current_teacher.lessons
      end
      if is_parent?
        @students = current_parent.students
        @lessons = current_parent.lessons.select { |l| l.teacher_id == params[:id] }
      end
      
      @teachers = [@teacher]
      @locations = @teacher.locations
      
      load_time_choices
    end
    load_times
    erb :"teachers/show"
  end
  
  post "/teachers/:id/lessons" do 
    logged_in_do? do 
      @lesson = Lesson.find(params[:lesson])
      @teacher = Teacher.find(params[:id])
      
      @students = current_teacher.students if is_teacher?
      @students = current_parent.students if is_parent?
      @students = current_student if is_student?
      
      @teachers = [@teacher]
      @locations = @teacher.locations
      load_times
      load_time_choices
      erb :"teachers/show"
    end
  end
  
  post "/teachers/:id/lessons/:lesson_id" do 
    logged_in_do? do
      # checks for proper permission before proceeding with the update
      has_permission?(is_teacher? && current_teacher.lessons.include?(Lesson.find(params[:lesson_id])) || is_parent? && current_parent.lessons.include?(Lesson.find(params[:lesson_id])) || is_student? && current_student.lessons.include?(Lesson.find(params[:lesson_id])) || is_admin?) do
        @lesson = Lesson.find(params[:lesson_id])
        student = Student.find(params[:lesson][:student].to_i)
        teacher = Teacher.find(params[:lesson][:teacher].to_i)
        lesson_time = DateTime.parse(params[:lesson][:lesson_time][:date] + " #{params[:lesson][:lesson_time][:hour]}:#{params[:lesson][:lesson_time][:minutes]}")
        location = Location.find(params[:lesson][:location].to_i)
        # makes sure objects are valid before saving
        if !student.is_a?(Student)
          erb :"lessons/edit", locals: { message: "Couldn't find that student." }
        elsif !teacher.is_a?(Teacher)
          erb :"lessons/edit", locals: { message: "Couldn't find that teacher." }
        elsif !lesson_time.is_a?(DateTime) || !validate_time(lesson_time)
          erb :"lessons/edit", locals: { message: "Please select a valid time" }
        elsif !location.is_a?(Location)
          erb :"lessons/edit", locals: { message: "Couldn't find that location" }
        end
        
        if is_teacher?
          # only allows the teacher to edit their own booking requests
          if @lesson.teacher == current_teacher
            @lesson.teacher = teacher
          else
            erb :failure, locals: { message: "You don't have permission to edit this booking request" }
          end
          # prevents teachers from chaning a booking request to belong to another student
          if @lesson.student != student
            erb :"lessons/edit", locals: { message: "Unable to change student." }
          end
          @lesson.lesson_time = lesson_time
          @lesson.location = location
        end
        
        if is_parent?
          
        end
        
        if is_admin?
          @lesson.student = student
          @lesson.teacher = teacher
          @lesson.lesson_time = lesson_time
          @lesson.location = location
        end
        
        if is_student?
          
        end
        
        if @lesson.save
          redirect "/teachers/#{teacher.id}"
        end
        
      end
    end
  end
    
end