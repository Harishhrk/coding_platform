class Problem < ApplicationRecord
    has_many :test_cases, dependent: :destroy
    has_many :submissions
    # Optionally, you can add validations
    validates :title, :description, presence: true
  end
  