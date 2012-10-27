#coding:utf-8
module PackHelper
end


class String

  def xss_defense!
    gsub!(/</, "&LT;")
    gsub!(/t\s*\:/,"t;")
  end


end

