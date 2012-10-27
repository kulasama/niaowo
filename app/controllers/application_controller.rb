class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :change_session_expiration_time

  def not_found(msg)
    raise ActionController::RoutingError.new(msg)
  end


  def change_session_expiration_time    
      request.session_options[:expire_after] = 1.years
  end
end
