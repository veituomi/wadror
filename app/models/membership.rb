class Membership < ActiveRecord::Base

	belongs_to :user
	belongs_to :beer_club
	
	validate :not_member_yet
	
	def not_member_yet
		club_with_same_id = user.beer_clubs.find_by id: beer_club.id;
		if club_with_same_id
			errors.add user.username, "is already in this beer club"
		end
	end
end
