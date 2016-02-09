require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"
    
    expect(user.username).to eq "Pekka"
  end
  
  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end
  
  describe "is not saved with an invalid password" do
    it "containing only lowercase letters" do
      user = User.create username:"Pekka", password:"invalid", password_confirmation:"invalid"
    
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
    
    it "that is too short" do
      user = User.create username:"Pekka", password:"1Nv", password_confirmation:"1Nv"
    
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
  end
  
  describe "with a proper password" do
    let(:user) { FactoryGirl.create :user }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
  
  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end
    
    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer:beer, user:user)

      expect(user.favorite_beer).to eq(beer)
    end
    
    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(user, 10, 20, 15, 7, 9)
      best = create_beer_with_rating(user, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end
  
  describe "favorite" do
  let(:user){FactoryGirl.create(:user) }
    
    describe "style" do
      let(:user){FactoryGirl.create(:user) }
      
      it "has method for determining one" do
        expect(user).to respond_to(:favorite_style)
      end
      
      it "without ratings does not have one" do
        expect(user.favorite_style).to eq(nil)
      end
      
      it "is the only rated if only one rating" do
        beer = FactoryGirl.create(:beer)
        rating = FactoryGirl.create(:rating, beer:beer, user:user)
  
        expect(user.favorite_style).to eq("Lager")
      end
      
      it "is the one with highest average rating if several rated" do
        create_beers_with_ratings(user, 10, 11)
        best = FactoryGirl.create(:beer_ipa)
        best.brewery = FactoryGirl.create(:brewery2)
        best_rating = FactoryGirl.create(:rating2)
        user.ratings << best_rating
        best.ratings << best_rating
        create_beers_with_ratings(user, 10, 15)
        
        expect(user.favorite_style).to eq("IPA")
      end
    end
    
    describe "brewery" do
      it "has method for determining one" do
        expect(user).to respond_to(:favorite_brewery)
      end
      
      it "without ratings does not have one" do
        expect(user.favorite_brewery).to eq(nil)
      end
      
      it "is the one with highest average rating if several rated" do
        create_beers_with_ratings(user, 10, 15)
        best = FactoryGirl.create(:beer_ipa)
        best_rating = FactoryGirl.create(:rating2)
        
        bad_brewery = FactoryGirl.create(:brewery)
        create_beer_with_rating_and_brewery(user, 21, bad_brewery)
        create_beer_with_rating_and_brewery(user, 1, bad_brewery)
        create_beer_with_rating_and_brewery(user, 12, bad_brewery)
        
        best.brewery = FactoryGirl.create(:brewery2)
        user.ratings << best_rating
        best.ratings << best_rating
        create_beers_with_ratings(user, 10, 15)
        
        expect(user.favorite_brewery).to eq(best.brewery)
      end
    end
  end
end

def create_beers_with_ratings(user, *scores)
  scores.each do |score|
    create_beer_with_rating user, score
  end
end

def create_beer_with_rating(user, score)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beer_with_rating_and_brewery(user, score, brewer)
  beer = FactoryGirl.create(:beer)
  brewer.id = 1
  beer.brewery = brewer
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end
