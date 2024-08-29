class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :problem

  after_create :update_user_statistics

  private

  def update_user_statistics
    user.update_statistics(self)
  end
end
