class User < ActiveRecord::Base
	include RatingAverage
	
	has_secure_password
	
	validates :username, uniqueness: true,
						 length: { minimum: 3, maximum: 15 }
	
	validates :password,
		presence: true,
		format: {with: /\A(?=.*[A-Z])(?=.*[0-9]).{4,}/x}
	
	has_many :ratings, dependent: :destroy
	has_many :beers, through: :ratings
	
	has_many :memberships, dependent: :destroy
	has_many :beer_clubs, through: :memberships
	
	def favorite_beer
		return nil if ratings.empty?
		ratings.order(score: :desc).limit(1).first.beer
	end
	
	def favorite_style
		return nil if ratings.empty?
		styles_by_rating_average
	end
	
	def favorite_brewery
		return nil if ratings.empty?
		breweries_by_rating_average
	end
	
	def styles_by_rating_average
		#best_key_of_ratings ratings.group_by(&:style)
		groups = rating_groups_by_average ratings.group_by(&:style)
		groups.max_by{|k,v| v}[0]
	end
	
	def breweries_by_rating_average
		groups = rating_groups_by_average ratings.group_by(&:brewery)
		groups.max_by{|k,v| v}[0]
	end
	
	# turha
	def best_key_of_ratings(groups)
		best_key = nil
		best_average = 0
		groups.each do |key, array|
			average = calculate_average_score array
			if best_average < average
				best_average = average
				best_key = key
			end
		end
		best_key
	end
	
	def rating_groups_by_average(groups)
		averages = Hash.new
		groups.each do |key, array|
			averages[key] = calculate_average_score array
		end
		averages
	end
	
	def calculate_average_score(array)
		sum = 0
		array.each { |rating|
			sum += rating.score
		}
		sum.to_f / array.length
	end
end
