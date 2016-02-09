class Beer < ActiveRecord::Base
	include RatingAverage

	belongs_to :brewery
	has_many :ratings, dependent: :destroy
	has_many :raters, -> { uniq }, through: :ratings, source: :user
	
	validates :name, length: { minimum: 1 }
	validates :style, length: { minimum: 1 }
	
	def to_s
		return name + ' - ' + brewery.name
	end
end
