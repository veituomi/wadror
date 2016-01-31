class Brewery < ActiveRecord::Base
	include RatingAverage
	
	has_many :beers, dependent: :destroy
	has_many :ratings, through: :beers
	
	validates :name, length: { minimum: 1 }
	
	validates :year, numericality: { greater_than_or_equal_to: 1042,
									 only_integer: true }
	validate :year_is_valid
	
	def year_is_valid
		if year > Time.now.year
			errors.add :year, "may not be in the future "
		end
	end
	
	def print_report
		puts self.name
		puts "established in year #{self.year}"
		puts "number of beers #{self.beers.count}"
	end
	
	def restart
		self.year = 2016
		puts "changed year to #{year}"
	end
end