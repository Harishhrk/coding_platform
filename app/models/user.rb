class User < ApplicationRecord
    has_secure_password
    has_many :submissions
  
    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true


    def update_statistics(submission)
      if submission.success
        increment!(:problems_solved)
        increment!(:total_time_spent, submission.time_taken)
      end
    end
  
    def average_time_per_problem
      problems_solved > 0 ? total_time_spent / problems_solved : 0
    end
  end
  