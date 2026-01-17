class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update, :activate, :deactivate, :destroy]

  def index
    authorize :admin, :manage_users?
    @users = policy_scope(User).order(created_at: :desc)
  end

  def new
    authorize :admin, :manage_users?
    @user = User.new
  end

  def create
    authorize :admin, :manage_users?
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: "User created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user

    if @user.update(user_params)
      redirect_to admin_users_path, notice: "User updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @user
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted."
  end

  def activate
    authorize @user, :activate?
    @user.update!(status: true)
    redirect_to admin_users_path, notice: "User activated."
  end

  def deactivate
    authorize @user, :deactivate?
    @user.update!(status: false)
    redirect_to admin_users_path, notice: "User deactivated."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name,
      :password,
      :password_confirmation,
      :role,
      :status
    )
  end
end
