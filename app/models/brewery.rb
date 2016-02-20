class Brewery < ActiveRecord::Base
	include RatingAverage
	
	scope :active, -> { where active:true }
	scope :retired, -> { where active:[nil,false] }
	
	has_many :beers, dependent: :destroy
	has_many :ratings, through: :beers
	
	validates :name, presence: true
	
	validates :year, numericality: { less_than_or_equal_to: ->(_) { Time.now.year} }
	
	def self.top(n)
		Brewery.all.sort_by{ |b| -(b.average_rating||0) }.take(n)
	end
	
	def to_s
		self.name
	end
end