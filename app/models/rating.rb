class Rating < ActiveRecord::Base
	scope :recent, -> { order(id: :desc).limit(5) }
	scope :best_styles, -> { order(id: :desc).limit(1) }
	
	belongs_to :beer
	belongs_to :user
	
	validates :score, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 50,
                                    only_integer: true }
	
	def style
		beer.style
	end
	
	def brewery
		beer.brewery.name
	end
	
	def to_s
		"#{beer.name} #{score}"
	end
end
