class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_admin, only: [:toggle_activity]
  # GET /users
  # GET /users.json
  def index
    @users = User.includes(:ratings, :beers).all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    return if @user == current_user

    redirect_to @user
  end

  def toggle_activity
    user = User.find(params[:id])
    user.update_attribute :active, !user.active

    new_status = user.active? ? "active" : "inactive"

    redirect_to user, notice: "user activity status changed to #{new_status}"
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.admin = false
    @user.active = true
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

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user == current_user
        if user_params[:username].nil? && @user == current_user && @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    return if @user != current_user

    @user.destroy
    session[:user_id] = nil
    redirect_to :root
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation, :active, :admin)
  end
end
