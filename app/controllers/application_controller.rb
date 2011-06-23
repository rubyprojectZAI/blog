class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
  
  def confirm_logged_in
    unless session[:user_id]
      flash[:notice] = "Musisz byc zalogowany"
      # redirect_to(:controller=>'posts', :action => 'index')
      return true
    else
      return true
    end
  end
  
end
