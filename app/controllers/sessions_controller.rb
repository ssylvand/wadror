class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password]) && user.blocked != true
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    else
      if user.blocked
        redirect_to :back, notice: "Your account is frozen, please contact admin"
      else
        redirect_to :back, notice: "Username and/or password mismatch"
      end
    end
  end

  def create_oauth
    user = User.find_or_create_with_auth_hash(request.env['omniauth.auth'])
    if user && user.blocked != true
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
    end
  else
    if user.blocked
      redirect_to :back, notice: "Your account is frozen, please contact admin"
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end