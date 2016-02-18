class StylesController < ApplicationController
  before_action :set_style, only: [:show, :edit, :update, :destroy]

  def index
    @styles = Style.all
  end
  
  def show
  end
  
  def new
    @user = User.new
  end

  def edit
  end

  def create
    @style = Style.new(style_params)

    respond_to do |format|
      if @style.save
        format.html { redirect_to @style, notice: 'Style was successfully created.' }
        format.json { render :show, status: :created, location: @style }
      else
        format.html { render :new }
        format.json { render json: @style.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @style.update(style_params)
        format.html { redirect_to @style, notice: 'Style was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @style.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @style.destroy
    
    respond_to do |format|
      format.html { redirect_to styles_path, notice: 'Style was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
  
  def set_style
    @style = Style.find(params[:id])
  end
  
  def style_params
    params.require(:style).permit(:name, :description)
  end
end