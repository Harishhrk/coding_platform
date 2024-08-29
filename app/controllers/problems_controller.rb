class ProblemsController < ApplicationController

  before_action :authenticate_request
  before_action :authorize_admin, only: [:create, :update, :destroy]

    def index
      @problems = Problem.all
      render json: @problems
    end
  
    def show
      @problem = Problem.find(params[:id])
      render json: @problem
    end
  
    def create
      @problem = Problem.new(problem_params)
      if @problem.save
        render json: @problem, status: :created
      else
        render json: @problem.errors, status: :unprocessable_entity
      end
    end
  
    def update
      @problem = Problem.find(params[:id])
      if @problem.update(problem_params)
        render json: @problem
      else
        render json: @problem.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      @problem = Problem.find(params[:id])
      @problem.destroy
      head :no_content
    end
  
    private
  
    def problem_params
      params.require(:problem).permit(:title, :description, :difficulty)
    end

    private

  def authorize_admin
    render json: { error: 'Access denied' }, status: :forbidden unless current_user.admin?
  end
  end
  