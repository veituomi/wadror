class Rating < ActiveRecord::Base
	belongs_to :beer
	
	def to_s
		return self.beer.name + " " + self.score.to_s
	end
end
