class TeachersController < ApplicationController 
  
  get "/teachers" do 
    @teachers = Teacher.all
    erb :"/teachers/index"
  end
  
  get "/teachers/:id" do 
    load_variables
    erb :"teachers/show"
  end
  
  get "/teachers/:id/students/new" do 
    logged_in_do? do
      if is_teacher? && current_teacher == Teacher.find(params[:id]) || is_admin?
        params[:add_teacher] = true
        erb :"/students/new"
      end
    end
  end
  
  post "/teachers/:id/lessons" do 
    "#{params}"
    @teacher = Teacher.find(params[:id])
    has_permission?(is_student? || is_parent? || is_teacher? && current_teacher == @teacher || is_admin? ) do
      @lesson = Lesson.new
      @lesson.student = Student.find(params[:lesson][:student])
      @lesson.teacher = Teacher.find(params[:id])
      @lesson.lesson_time = DateTime.parse(params[:lesson][:lesson_time][:date] + " #{params[:lesson][:lesson_time][:hour]}:#{params[:lesson][:lesson_time][:minutes]}")
      @lesson.location = Location.find(params[:lesson][:location])
      @lesson.duration = params[:lesson][:duration].to_i
      @lesson.student = Student.create(params[:student]) if params[:student][:name] != ""
      @lesson.location = Location.create(city: params[:location][:city]) if params[:location][:city] != ""
      @lesson.save
      load_variables
      erb :"/teachers/show"
    end
    
    
    # logged_in_do? do 
    #   if is_teacher? && current_teacher == Teacher.find(params[:id]) || is_admin?
          
    #   end
    # end
  end
  
  get "/teachers/:id/lessons/:lesson_id/edit" do
    # loads the edit page for a lesson linked from the 
    # teacher's show page (clicking on a lesson)
    logged_in_do? do
      @teacher = Teacher.find(params[:id])
      @lesson = Lesson.find(params[:lesson_id])
      has_permission?(is_student? && current_student.lessons.include?(@lesson) || is_parent? && current_parent.lessons.include?(@lesson) || is_teacher? && current_teacher.lessons.include?(@lesson) || is_admin?) do
        @lessons = []
        @lessons = current_teacher.lessons if is_teacher?
        
        @students = current_parent.students if is_parent?
        @students = [current_student] if is_student?
        @students = [@lesson.student] if is_teacher?
          
        @teachers = [@teacher]
        @locations = @teacher.locations
        load_times
        load_time_choices
        @can_edit = true
        erb :"teachers/show"
      end
    end
  end
  
  post "/teachers/:id/lessons/edit" do 
    # accepts form submission choosing 
    # to edit a particular lesson from
    # the select field on the teacher 
    # show page (reloads show page with
    # edit lesson form for 
    # selected lesson)
    logged_in_do? do 
      @lesson = Lesson.find(params[:lesson_id])
      @teacher = Teacher.find(params[:id])
      
      @lessons = []
      @lessons = current_teacher.lessons if is_teacher?
      
      
      @students = current_parent.students if is_parent?
      @students = [current_student] if is_student?
      @students = [@lesson.student] if is_teacher?
        
      
      @teachers = [@teacher]
      @locations = @teacher.locations
      load_times
      load_time_choices
      erb :"teachers/show"
    end
  end
  
  post "/teachers/:id/lessons/:lesson_id" do 
    # accepts the edit lesson form 
    # revealed on the teacher's show
    # page after choosing a lesson to edit
    logged_in_do? do
      # checks for proper permission before proceeding with the update
      has_permission?(is_teacher? && current_teacher.lessons.include?(Lesson.find(params[:lesson_id])) || is_parent? && current_parent.lessons.include?(Lesson.find(params[:lesson_id])) || is_student? && current_student.lessons.include?(Lesson.find(params[:lesson_id])) || is_admin?) do
        @lesson = Lesson.find(params[:lesson_id])
        student = Student.find(params[:lesson][:student].to_i)
        teacher = Teacher.find(params[:lesson][:teacher].to_i)
        lesson_time = DateTime.parse(params[:lesson][:lesson_time][:date] + " #{params[:lesson][:lesson_time][:hour]}:#{params[:lesson][:lesson_time][:minutes]}")
        duration = params[:lesson][:duration]
        location = Location.find(params[:lesson][:location].to_i)
        
        if is_teacher?
          # only allows the teacher to edit their own lessons
          if @lesson.teacher == current_teacher
            @lesson.teacher = teacher
          else
            erb :failure, locals: { message: "You don't have permission to edit this lesson" }
          end
          # prevents teachers from
          # changing a lesson to belong 
          # to another student
          if @lesson.student != student
            erb :"lessons/edit", locals: { message: "Unable to change student." }
          end
          @lesson.lesson_time = lesson_time
          @lesson.location = location
          @lesson.duration = duration
        end
        
        if is_parent?
          
        end
        
        if is_admin?
          @lesson.student = student
          @lesson.teacher = teacher
          @lesson.lesson_time = lesson_time
          @lesson.location = location
          @lesson.duration = duration
        end
        
        if is_student?
          
        end
        
        if @lesson.save
          redirect "/teachers/#{teacher.id}"
        else
          load_variables
          erb :"/teachers/show"
        end
        
      end
    end
  end
  
  helpers do 
    def load_variables
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
    end
  end
    
end