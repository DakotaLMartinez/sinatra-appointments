class Lesson < ActiveRecord::Base
  include ActiveModel::Validations
  belongs_to :student
  belongs_to :teacher
  belongs_to :location
  
  # validates_associated :student, :teacher, :location
  validates_numericality_of :duration, only_integer: true
  validates_inclusion_of :duration, in: [1800, 2700, 3600, 4500, 5400]
  validate do |lesson|
    LessonTimeValidator.new(lesson).validate  
  end
end

class LessonTimeValidator
  def initialize(lesson)
    @lesson = lesson
    @teacher = @lesson.teacher
  end
  
  def validate
    validate_lesson_time
    
  end
  
  def validate_lesson_time
    # stores today's lessons
    lessons = @teacher.lessons.select { |l| @lesson.lesson_time.midnight == l.lesson_time.midnight }
    # makes sure today's lessons don't overlap with the new lesson
    # first checks is another lesson is still in progress when the new lesson is set to start.
    # next checks if the new lesson would be still in progress when any of the other lessons are set to start.
    lessons.each do |lesson|
      if @lesson != lesson
        if lesson.lesson_time < @lesson.lesson_time && @lesson.lesson_time < lesson.lesson_time + lesson.duration.seconds || @lesson.lesson_time < lesson.lesson_time && lesson.lesson_time < @lesson.lesson_time + @lesson.duration.seconds
          @lesson.errors.add(:lesson_time, "is not available.")
        end
      end
    end
  end
  
end