class Style < ActiveRecord::Base
	has_many :beers
	
	def to_s
		self.name
	end
end

# Beer.uniq.pluck(:style).each { |x| Style.create(name: x, description: "No description added") }

# Beer.all.each { |x| x.update_attribute(:style, Style.find_by(name: x.old_style)) }