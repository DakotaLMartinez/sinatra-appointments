class TeachersController < ApplicationController 
  
  ####### Admin Routes #######

  get "/admin/teachers" do 
    @teachers = Teacher.all
    erb :"/teachers/index"
  end
  
  get "/admin/teachers/:id" do 
    @teacher = Teacher.find(params[:id])
    @current_user = 'admin'
    @times = {0 => "12 AM"}.merge!(1.upto(11).collect { |n| {n => "#{n} AM" } }.reduce(Hash.new, :merge)).merge!({12 => "12 PM"}).merge!(1.upto(11).collect { |n| {n + 12 => "#{n} PM"} }.reduce(Hash.new, :merge))
    erb :"/teachers/show"
  end
    
end