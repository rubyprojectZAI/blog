class AccessController < ApplicationController
  def login
  end
  
  def attempt_login
    autorized_user = User.authenticate(params[:login], params[:password])
    
    if autorized_user
      session[:user_id] = autorized_user.id
      session[:login] = autorized_user.login
      flash[:notice] = "You are log in" 
      redirect_to(:action => 'login')
    else
      flash[:notice] = "Invalide login/password"
      redirect_to(:action => 'login')
    end
  end
  
  def logout
    session[:user_id] = nil
    session[:login] = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => 'login')
  end

end
