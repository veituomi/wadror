class Brewery < ActiveRecord::Base
	include RatingAverage
	
	scope :active, -> { where active:true }
	scope :retired, -> { where active:[nil,false] }
	
	has_many :beers, dependent: :destroy
	has_many :ratings, through: :beers
	
	validates :name, presence: true
	
	#validates :year, numericality: { greater_than_or_equal_to: 1042, only_integer: true }
	validates :year, numericality: { less_than_or_equal_to: ->(_) { Time.now.year} }
	
	def self.top(n)
		Brewery.all.sort_by{ |b| -(b.average_rating||0) }.take(n)
	end
end