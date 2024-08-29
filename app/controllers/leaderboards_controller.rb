class LeaderboardsController < ApplicationController
    def index
        @leaderboard = User.where(admin: false)  # Exclude admins
        .where.not(problems_solved: [nil, 0])  # Exclude users with nil or 0 problems solved
        .order(problems_solved: :desc, total_time_spent: :asc)
        .limit(10)
      render json: @leaderboard.map { |user| leaderboard_entry(user) }
    end
  
    private
  
    def leaderboard_entry(user)
      {
        username: user.username,
        problems_solved: user.problems_solved,
        average_time: user.average_time_per_problem
      }
    end
  end
  