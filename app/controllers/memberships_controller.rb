class MembershipsController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :set_membership, only: [:show, :edit, :update, :destroy]

  def index
    @memberships = Membership.all
  end

  def show
  end

  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.all
    @user = current_user
  end
  
  def confirm
    set_membership
    if current_user and current_user.memberships.confirmed.find_by beer_club: @membership.beer_club.id
      @membership.update_attribute :confirmed, true
    end
    redirect_to @membership.beer_club
  end

  def edit
  end

  def create
    @membership = Membership.new(membership_params)
    @user = current_user
    
    @membership.user_id = @user.id
    @membership.confirmed = false

    respond_to do |format|
      if @membership.save
        current_user.memberships << @membership
        format.html { redirect_to @membership.beer_club, notice: @user.username + ', welcome to the club!' }
        format.json { render :show, status: :created, location: @membership }
      else
        @beer_clubs = BeerClub.all
        format.html { render :new }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to @membership.user, notice: 'Membership in ' + @membership.beer_club.name + ' ended.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:beer_club_id, :user_id)
    end
end
