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
        @booking_requests = current_student.booking_requests.select { |br| br.teacher_id == params[:id] }
      end
      if is_teacher?
        @students = current_teacher.students
        @booking_requests = current_teacher.booking_requests
      end
      if is_parent?
        @students = current_parent.students
        @booking_requests = current_parent.booking_requests.select { |br| br.teacher_id == params[:id] }
      end
      
      @teachers = [@teacher]
      @locations = @teacher.locations
      
      load_time_choices
    end
    load_times
    erb :"teachers/show"
  end
  
  post "/teachers/:id/booking_requests" do 
    logged_in_do? do 
      @booking_request = BookingRequest.find(params[:booking_request])
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
  
  post "/teachers/:id/booking_requests/:br_id" do 
    logged_in_do? do
      # checks for proper permission before proceeding with the update
      has_permission?(is_teacher? && current_teacher.booking_requests.include?(BookingRequest.find(params[:br_id])) || is_parent? && current_parent.booking_requests.include?(BookingRequest.find(params[:br_id])) || is_student? && current_student.booking_requests.include?(BookingRequest.find(params[:br_id])) || is_admin?) do
        @booking_request = BookingRequest.find(params[:br_id])
        student = Student.find(params[:booking_request][:student].to_i)
        teacher = Teacher.find(params[:booking_request][:teacher].to_i)
        lesson_time = DateTime.parse(params[:booking_request][:lesson_time][:date] + " #{params[:booking_request][:lesson_time][:hour]}:#{params[:booking_request][:lesson_time][:minutes]}")
        location = Location.find(params[:booking_request][:location].to_i)
        # makes sure objects are valid before saving
        if !student.is_a?(Student)
          erb :"booking_requests/edit", locals: { message: "Couldn't find that student." }
        elsif !teacher.is_a?(Teacher)
          erb :"booking_requests/edit", locals: { message: "Couldn't find that teacher." }
        elsif !lesson_time.is_a?(DateTime) || !validate_time(lesson_time)
          erb :"booking_requests/edit", locals: { message: "Please select a valid time" }
        elsif !location.is_a?(Location)
          erb :"booking_requests/edit", locals: { message: "Couldn't find that location" }
        end
        
        if is_teacher?
          # only allows the teacher to edit their own booking requests
          if @booking_request.teacher == current_teacher
            @booking_request.teacher = teacher
          else
            erb :failure, locals: { message: "You don't have permission to edit this booking request" }
          end
          # prevents teachers from chaning a booking request to belong to another student
          if @booking_request.student != student
            erb :"booking_requests/edit", locals: { message: "Unable to change student." }
          end
          @booking_request.lesson_time = lesson_time
          @booking_request.location = location
        end
        
        if is_parent?
          
        end
        
        if is_admin?
          @booking_request.student = student
          @booking_request.teacher = teacher
          @booking_request.lesson_time = lesson_time
          @booking_request.location = location
        end
        
        if is_student?
          
        end
        
        if @booking_request.save
          redirect "/teachers/#{teacher.id}"
        end
        
      end
    end
  end
    
end