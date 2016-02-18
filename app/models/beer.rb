class Beer < ActiveRecord::Base
	include RatingAverage

	belongs_to :brewery
	belongs_to :style
	
	has_many :ratings, dependent: :destroy
	has_many :raters, -> { uniq }, through: :ratings, source: :user
	
	validates :name, length: { minimum: 1 }
	validates :style, presence: true
	
	def to_s
		return name + ' - ' + brewery.name
	end
end
