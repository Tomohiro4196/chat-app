class UsersController < ApplicationController

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path
    else 
      render action :edit
    end
  end

  def destory
    redirect_to new_user_session_path
  end


  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
