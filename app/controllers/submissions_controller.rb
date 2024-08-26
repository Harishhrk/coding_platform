class SubmissionsController < ApplicationController

    before_action :authenticate_request, only: [:create, :index]


    def create
      problem = Problem.find(params[:problem_id])
      code = params[:code]
      language = params[:language] || 'python'
      
      service = CodeExecutionService.new(code, language)
      result = service.execute(problem)
      
      # Save the submission result
      submission = current_user.submissions.create(
        problem: problem,
        code: code,
        language: language,
        output: result[:results].map { |r| "Input: #{r[:input]}, Output: #{r[:output]}, Expected: #{r[:expected_output]}" }.join("\n"),
        success: result[:success]
      )
    
      if result[:success]
        render json: { message: 'Code executed successfully', results: result[:results] }, status: :ok
      else
        render json: { message: 'Code execution failed', results: result[:results] }, status: :unprocessable_entity
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
  