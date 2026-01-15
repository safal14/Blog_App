class Admin::UsersController < ApplicationController
  before_action :authenticate_user!          # ← replace with your actual auth method if different (authenticate!, require_login, etc.)
  before_action :require_admin!
  before_action :set_user, only: [:edit, :update, :activate, :deactivate]

  def index
    @users = policy_scope(User).order(created_at: :desc)
  end

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user

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

  def activate
    authorize @user
    @user.update!(status: true)
    redirect_to admin_users_path, notice: "User activated."
  end

  def deactivate
    authorize @user
    @user.update!(status: false)
    redirect_to admin_users_path, notice: "User deactivated."
  end
   def destroy
    @user = User.find(params[:id])
    authorize @user               # ← this uses Pundit
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted."
  end

  private

  def require_admin!
    unless current_user&.admin?   # ← adjust if your admin check is different (current_user.role == 'admin', current_user.is_admin?, etc.)
      flash[:alert] = "Only admins can access this area."
      redirect_to root_path
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name,                  # ← add/remove fields you actually have
      :password,
      :password_confirmation,
      :role
    )
  end
 
end