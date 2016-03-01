class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :toggle_banned]
  before_action :ensure_being_admin, only: [:toggle_banned]

  # GET /users
  # GET /users.json
  def index
    @users = User.includes(:ratings, :beers).all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @confirmed_memberships = @user.memberships.confirmed
    @pending_memberships = @user.memberships.pending
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if user_params[:username].nil? and @user == current_user and @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if current_user == @user
      @user.destroy
      session[:user_id] = nil
      
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      redirect_to breweries_path
    end
  end
  
  def toggle_banned
    if @user.banned
      @user.update_attribute(:banned, false)
    else
      @user.update_attribute(:banned, true)
    end
    redirect_to :back, notice:"User status successfully changed"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
end
