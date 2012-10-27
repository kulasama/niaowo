require 'rdiscount'
module TopicsHelper
	def markdown(content)
		markdown = RDiscount.new(content)
		markdown.to_html
	end


end
