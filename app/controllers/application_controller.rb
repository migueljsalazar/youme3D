class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_designer
  helper_method :current_supplier

  def current_designer
    @current_designer ||= Designer.find_by(id: session[:designer_id])
  end

  def current_supplier
    @current_supplier ||= Supplier.find_by(id: session[:supplier_id])
  end

  def require_logged_in
    return true if current_designer || current_supplier
    return false
  end

end
