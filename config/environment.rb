# Load the rails application
require File.expand_path('../application', __FILE__)


class Logger    
  def format_message(level, time, progname, msg)    
     "[#{time.to_s(:db)}] #{level} -- #{msg}\n"    
  end    
end 

 

# Initialize the rails application
Niaowo::Application.initialize!
