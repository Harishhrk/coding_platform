class RegisterUser < ActiveInteraction::Base
    string :username
    string :email
    string :password
  
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, length: { minimum: 6 }
  
    def execute
      user = User.new(inputs)
      if user.save
        user
      else
        errors.merge!(user.errors)
        nil
      end
    end
  end
  