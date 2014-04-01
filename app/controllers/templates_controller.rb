class TemplatesController < ApplicationController
	helper TemplatesHelper
	
  before_action :set_template, only: [:show, :update, :destroy, :edit, :append]
	
  # GET /templates
  # GET /templates.json
  def clear
    Template.destroy_all
    respond_to do |format|
      format.html { redirect_to templates_url }
    end
  end

  # GET /templates
  # GET /templates.json
  def index
    @templates = Template.all
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
  end

  # GET /templates/new
  def new
		@id = nil
  end

  # GET /templates/1/edit
  def edit
		@id = params[:id]
  end

  # POST /templates
  # POST /templates.json
  def create
    @template = Template.new(template_params)

    respond_to do |format|
      if @template.save
        format.html { redirect_to @template, notice: 'Template was successfully created.' }
        format.json { render action: 'show', status: :created, location: @template }
      else
        format.html { render action: 'new' }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
    respond_to do |format|
      if @template.update(template_params)
        format.html { redirect_to @template, notice: 'Template was successfully updated.' }
        format.json { render action: 'show', status: :accepted, location: @template }
      else
        format.html { render action: 'edit' }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    @template.destroy
    respond_to do |format|
      format.html { redirect_to templates_url }
      format.json { head :no_content }
    end
  end
	
  def append
		exam = session[:current_exam]
		@template.append(exam)
		respond_to do |format|
			format.js   {}
		end
	end
	
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template
      @template = Template.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_params
      params[:template].permit(:question)
    end
end
