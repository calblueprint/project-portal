class QuestionsController < ApplicationController
  before_filter :authorize_user
  
  def index
    @questions = Question.current_questions
  end

  def show
    @question = Question.find(params[:id])
  end

  def new
    @question = Question.new
  end

  def edit
    @question = Question.find(params[:id])
  end

  def create
    @question = Question.new(params[:question])
    if @question.save
      flash[:notice] = 'Question was successfully created.' 
      redirect_to action: "index"
    else
      render action: "new"
    end
  end

  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(params[:question])
      flash[:notice] = 'Question was successfully updated.' 
      redirect_to action: "index"
    else
      render action: "edit"
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.deleted = true
    @question.save
    redirect_to session[:return_to]
  end
  
end
