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
  
  get "/students/new" do
    logged_in_do? do
      @teachers = Teacher.all
      erb :"/students/new"
    end
  end
  
  post "/students" do 
    error_message = ""
    @student = Student.new
    # validates presence of and adds student name
    if params[:student][:name] != ""
      @student.name = params[:student][:name]
    else
      error_message += "Please enter a name for the student. "
    end
    # validates presence of and adds student email address
    VALID_EMAIL_REGEX = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
    if params[:student][:email] != "" && params[:student][:email].match(VALID_EMAIL_REGEX)
        @student.email = params[:student][:email]
    else
      error_message += "Please enter a valid email address. "
    end
    # checks student's preferred contact method and validates for phone
    # accordingly (phone number is not required unless selected as 
    # the preferred contact method)
    VALID_PHONE_REGEX = /\A(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}\z/
    if params[:student][:contact_method] == "phone"
      if params[:student][:phone_number] != "" && params[:student][:phone_number].match(VALID_PHONE_REGEX)
        @student.phone_number = params[:student][:phone_number]
      else 
        error_message += "Please enter a valid phone number: (123) 456-7890 "
      end
    else
      if params[:student][:phone_number] != "" && params[:student][:phone_number].match(VALID_PHONE_REGEX)
        @student.phone_number = params[:student][:phone_number]
      end
    end
    # validates contact method 
    if params[:student][:contact_method] == "phone" || params[:student][:contact_method] == "email"
      @student.contact_method = params[:student][:contact_method]
    else
      error_message += "Please select a preferred contact method (phone or email)"
    end
    # loads the show page for the student if there were no errors
    if error_message == ""
      @student.user_id = session[:id]
      @student.save
      @teachers = Teacher.all
      load_times
      erb :"students/show"
    else
      erb :"/students/new", locals: { message: error_message }
    end
    
  end
  
  get "/students/:id" do 
    logged_in_do? do
      id = params[:id].to_i
      has_permission?(is_student? && current_student.id == id || is_teacher? && current_teacher.students.include?(Student.find(id)) || is_admin?) do 
        @student = Student.find(params[:id])
        @teachers = Teacher.all
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

    