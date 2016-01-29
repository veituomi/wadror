class Beer < ActiveRecord::Base
	include RatingAverage

	belongs_to :brewery
	has_many :ratings, dependent: :destroy
	
	#def average_rating
		#if ratings.count > 0
			#sum = 0
			
			#return ratings.average(:score)
			
			#ratings.map { |s| sum += s.score }
			
			#ratings.each do |rating|
			#	sum += rating.score
			#end
			
			#return sum / ratings.count
		#end
		#return 0
	#end
	
	def to_s
		return name + ' - ' + brewery.name
	end
end
