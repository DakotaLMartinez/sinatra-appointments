class ParentsController < ApplicationController
  
  get "/parents" do 
    logged_in_do? do
      has_permission?(is_admin? || is_teacher?) do
        is_admin? ? @parents = Parent.all : nil
        is_teacher? ? @parents = current_teacher.parents : nil
        erb :"/parents/index"
      end
    end
  end
  
  get "/parents/:id" do
    logged_in_do? do 
      has_permission?(is_admin? || is_teacher? || is_parent?) do 
        is_admin? ? @parent = Parent.find(params[:id].to_i) : nil
        has_permission?( is_teacher? && current_teacher.parents.include?(Parent.find(params[:id])) ) do
          @parent = Parent.find(params[:id])
        end
        has_permission?(is_parent? && current_parent.id == params[:id].to_i) do
          @parent = Parent.find(params[:id])
        end
        erb :"/parents/show"
      end
    end
  end
    
end