class TestCasesController < ApplicationController
    before_action :set_problem
    before_action :authenticate_request
    before_action :authorize_admin, only: [:create, :update, :destroy]
  
    def index
      @test_cases = @problem.test_cases
    end
  
    def new
      @test_case = @problem.test_cases.new
    end
  
    def create
      @test_case = @problem.test_cases.new(test_case_params)
      if @test_case.save
        redirect_to problem_test_cases_path(@problem), notice: 'Test case created successfully.'
      else
        render :new
      end
    end
  
    def destroy
      @test_case = @problem.test_cases.find(params[:id])
      @test_case.destroy
      redirect_to problem_test_cases_path(@problem), notice: 'Test case deleted successfully.'
    end
  
    private
  
    def set_problem
      @problem = Problem.find(params[:problem_id])
    end
  
    def test_case_params
      params.require(:test_case).permit(:input, :expected_output)
    end

    def authorize_admin
        render json: { error: 'Access denied' }, status: :forbidden unless current_user.admin?
      end
  end
  