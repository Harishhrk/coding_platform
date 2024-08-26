class SubmissionsController < ApplicationController

    before_action :authenticate_request, only: [:create, :index]


  def create
    problem = Problem.find(params[:problem_id])
    code = params[:code]
    language = params[:language] || 'python'  # Default to Python
    Rails.logger.debug "Problem :#{problem}"

    # Execute the code
    service = CodeExecutionService.new(code, language)
    result = service.execute

    Rails.logger.debug "service :#{service}"
    Rails.logger.debug "result :#{result}"
    # Save the submission result
    submission = current_user.submissions.create(
      problem: problem,
      code: code,
      language: language,
      output: result[:output],
      success: result[:success]
    )

    if result[:success]
      render json: { message: 'Code executed successfully', output: result[:output] }, status: :ok
    else
      render json: { message: 'Code execution failed', output: result[:output] }, status: :unprocessable_entity
    end
  end
  
    def show
      @submission = Submission.find(params[:id])
      render json: @submission
    end
  
    def index
      @submissions = Submission.all
      render json: @submissions
    end
  
    private
  
    def submission_params
      params.require(:submission).permit(:user_id, :problem_id, :code, :status, :result)
    end
  end
  