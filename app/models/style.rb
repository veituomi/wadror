class Style < ActiveRecord::Base
	has_many :beers
	has_many :ratings, through: :beers
	
	def self.top(n)
		Style.all.sort_by {|style| style.average_rating }.reverse.take n
	end
	
	def average_rating
		return 0 if ratings.length == 0
		sum = 0
		ratings.each { |rating|
			sum += rating.score
		}
		sum.to_f / ratings.length
	end
	
	def to_s
		self.name
	end
end

# Beer.uniq.pluck(:style).each { |x| Style.create(name: x, description: "No description added") }

# Beer.all.each { |x| x.update_attribute(:style, Style.find_by(name: x.old_style)) }