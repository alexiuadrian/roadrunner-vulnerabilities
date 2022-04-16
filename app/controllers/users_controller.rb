class UsersController < ApplicationController
  before_action :authorized, only: [:auto_login]

  def index
    @users = User.all

    authorize @users

    render json: @users, status: :ok
  end

  # GET /users/{username}
  def show
    set_user
    authorize @user_to_be_modified
    render json: @user_to_be_modified, status: :ok
  end

  # REGISTER
  def create
    @user = User.create(user_params)

    @user.add_role(:user)

    if @user.valid?

      token = encode_token({user_id: @user.id})
      render json: {user: @user, token: token}
    else
      render json: {error: "Invalid username or password"}
    end
  end

  # LOGGING IN
  def login
    @user = User.find_by(username: params[:username])

    is_admin = false
    if @user.roles.find_by(name: 'admin')
      is_admin = true
    end

    is_user_manager = false
    if @user.roles.find_by(name: 'user_manager')
      is_user_manager = true
    end

    if @user && @user.authenticate(params[:password])
      token = encode_token({user_id: @user.id, is_admin: is_admin, is_user_manager: is_user_manager})
      render json: {user: @user, token: token}
    else
      render json: {error: "Invalid username or password"}
    end
  end

  # PUT /users/{id}
  def update
    set_user
    authorize @user_to_be_modified
    unless @user_to_be_modified.update(user_params)
      render json: { errors: @user_to_be_modified.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # DELETE /users/{id}
  def destroy
    set_user
    authorize @user_to_be_modified
    @user_to_be_modified.destroy
  end

  def auto_login
    render json: @user
  end

  # POST /user_roles/{id}
  def user_roles
    set_user

    authorize @user_to_be_modified

    # Add/remove the roles from the parameters to the user
    if params[:is_admin] && !@user_to_be_modified.roles.find_by(name: 'admin')
      @user_to_be_modified.add_role :admin
    end

    if !params[:is_admin] && @user_to_be_modified.roles.find_by(name: 'admin')
      @user_to_be_modified.remove_role :admin
    end


    if params[:is_user_manager] && !@user_to_be_modified.roles.find_by(name: 'user_manager')
      @user_to_be_modified.add_role :user_manager
    end

    if !params[:is_user_manager] && @user_to_be_modified.roles.find_by(name: 'user_manager')
      @user_to_be_modified.remove_role :user_manager
    end


    if params[:is_user] && !@user_to_be_modified.roles.find_by(name: 'user')
      @user_to_be_modified.add_role :user
    end

    if !params[:is_user] && @user_to_be_modified.roles.find_by(name: 'user')
      @user_to_be_modified.remove_role :user
    end

  end

  # GET /get_user_roles/{id}
  def get_user_roles
    set_user

    authorize @user_to_be_modified

    @roles = @user_to_be_modified.roles

    render json: @roles
  end

  private

  def set_user
    @user_to_be_modified = User.find_by(id: params[:id])
  end

  def user_params
    params.permit(:username, :email, :password, :password_confirmation, :is_admin, :is_user_manager, :is_user)
  end
end
