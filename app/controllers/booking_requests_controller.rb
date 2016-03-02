class BookingRequestsController < ApplicationController
  
  get "/booking_requests" do 
    logged_in_do? do 
      is_admin? ? @booking_requests = BookingRequest.order("lesson_time DESC") : nil
      is_teacher? ? @booking_requests = current_teacher.booking_requests.order("lesson_time DESC") : nil
      is_parent? ? @booking_requests = current_parent.booking_requests.order("lesson_time DESC") : nil
      is_student? ? @booking_requests = current_student.booking_requests.order("lesson_time DESC") : nil
      erb :"booking_requests/index" if @booking_requests
    end
  end
  
  get "/past/booking_requests" do 
    logged_in_do? do 
      is_admin? ? @booking_requests = BookingRequest.order("lesson_time DESC").select { |l| l.lesson_time < DateTime.now } : nil
      is_teacher? ? @booking_requests = current_teacher.booking_requests.order("lesson_time DESC").select { |l| l.lesson_time < DateTime.now } : nil
      is_parent? ? @booking_requests = current_parent.booking_requests.order("lesson_time DESC").select { |l| l.lesson_time < DateTime.now } : nil
      is_student ? @booking_requests = current_student.booking_requests.order("lesson_time DESC").select { |l| l.lesson_time < DateTime.now } : nil
      erb :"booking_requests/index" if @booking_requests
    end
  end
  
  get "/booking_requests/:id" do 
    logged_in_do? do 
      has_permission?(is_teacher? && current_teacher.booking_requests.include?(BookingRequest.find(params[:id])) || is_parent? && current_parent.booking_requests.include?(BookingRequest.find(params[:id])) || is_student? && current_student.booking_requests.include?(BookingRequest.find(params[:id])) || is_admin?) do
        @booking_request = BookingRequest.find(params[:id])
        erb :"booking_requests/show"
      end
    end
  end
  
  get "/booking_requests/:id/edit" do 
    logged_in_do? do 
      has_permission?(is_teacher? && current_teacher.booking_requests.include?(BookingRequest.find(params[:id])) || is_parent? && current_parent.booking_requests.include?(BookingRequest.find(params[:id])) || is_student? && current_student.booking_requests.include?(BookingRequest.find(params[:id])) || is_admin?) do
        if is_teacher?
          @students = current_teacher.students
          @locations = current_teacher.locations
          @teachers = [current_teacher]
        end
        if is_parent?
          @students = current_parent.students
          @locations = current_parent.locations
          @teachers = Teacher.all
        end
        if is_admin?
          @students = Student.all
          @locations = Location.all
          @teachers = Teacher.all
        end
        load_time_choices
        # binding.pry
        @booking_request = BookingRequest.find(params[:id])
        erb :"booking_requests/edit"
      end
    end
  end
  
  post "/booking_requests/:id" do 
    "#{params}"
    # time_string = params[:lesson_time][:date] + " #{params[:lesson_time][:hour]}:#{params[:lesson_time][:minutes]}"
    # DateTime.parse(time_string).strftime('%A, %b %e, %I:%M %p')
    logged_in_do? do
      has_permission?(is_teacher? && current_teacher.booking_requests.include?(BookingRequest.find(params[:id])) || is_parent? && current_parent.booking_requests.include?(BookingRequest.find(params[:id])) || is_student? && current_student.booking_requests.include?(BookingRequest.find(params[:id])) || is_admin?) do
        @booking_request = BookingRequest.find(params[:id])
        student = Student.find(params[:student].to_i)
        teacher = Teacher.find(params[:teacher].to_i)
        lesson_time = DateTime.parse(params[:lesson_time][:date] + " #{params[:lesson_time][:hour]}:#{params[:lesson_time][:minutes]}")
        location = Location.find(params[:location].to_i)
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
          if teacher.is_a?(Teacher) && @booking_request.teacher == current_teacher
            @booking_request.teacher = teacher
          else
            erb :failure, locals: { message: "You don't have permission to edit this booking request" }
          end
          if lesson_time.is_a?(DateTime) && validate_time(lesson_time)
            @booking_request.lesson_time = lesson_time
          else
            erb :failure, locals: { message: "Please select a valid time" }
          end
          if student.is_a?(Student) && @booking_request.student != student
            erb :"booking_requests/edit", locals: { message: "Unable to change student." }
          end
          if location.is_a?(Location) 
            @booking_request.location = location
          end
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
          redirect "/booking_requests/#{@booking_request.id}"
        end
        
      end
    end
  end
    
end