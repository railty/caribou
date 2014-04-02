class ExamsController < ApplicationController
  before_action :set_exam, only: [:show, :edit, :update, :destroy, :set_active]

  # GET /exams
  # GET /exams.json
  def index
    @exams = Exam.all.order("created_at desc")
  end

  # GET /exams/1
  # GET /exams/1.json
  def show
		material = nil
		material = params[:material]  if params[:material] != nil
    if material == nil then
      @questions = @exam.questions.where("material = 'md' or material = 'html'")
    else
      @questions = @exam.questions.where("material = ?", material)
    end

  end

  # GET /exams/new
  def new
    @exam = Exam.new
  end

  # GET /exams/1/edit
  def edit
  end

  # POST /exams
  # POST /exams.json
  def create
    @exam = Exam.new(exam_params)

    respond_to do |format|
      if @exam.save
        format.html { redirect_to @exam, notice: 'Exam was successfully created.' }
        format.json { render action: 'show', status: :created, location: @exam }
      else
        format.html { render action: 'new' }
        format.json { render json: @exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exams/1
  # PATCH/PUT /exams/1.json
  def update
    respond_to do |format|
      if @exam.update(exam_params)
        format.html { redirect_to @exam, notice: 'Exam was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @exam.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exams/1
  # DELETE /exams/1.json
  def destroy
    @exam.destroy
    respond_to do |format|
      format.html { redirect_to exams_url }
      format.json { head :no_content }
    end
  end
	
  def set_active
		session[:current_exam] = @exam.id
		respond_to do |format|
			format.js   {}
		end
	end
	
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam
      @exam = Exam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exam_params
      params[:exam].permit(:name, :grade)
    end
end
