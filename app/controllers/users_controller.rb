class UsersController < ApplicationController
  before_action :signed_in_user,
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :set_user,        only: [:show, :following, :followers]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: :destroy
  before_action :redirect_signed, only: [:new, :create]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated.'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = 'Welcome to the Sample App!'
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted.'
    redirect_to users_url
  end

  def following
    @title = 'Following'
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def correct_user
      set_user
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def redirect_signed
      redirect_to(root_url) if signed_in?
    end
end
