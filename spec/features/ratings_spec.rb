require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:style) { FactoryGirl.create :style_lager }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery, style:style }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery, style:style }
  let!(:user) { FactoryGirl.create :user }
  let!(:user2) { FactoryGirl.create :user2 }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
  
  describe "when exists" do
    let!(:rating1) { FactoryGirl.create :rating, score:15, beer:beer1, user:user }
    let!(:rating2) { FactoryGirl.create :rating, score:17, beer:beer1, user:user2 }
    
    it "is shown in list of all ratings" do
      visit ratings_path
      
      expect(page).to have_content "Number of ratings 2"
      expect(page).to have_content rating1.to_s + " Pekka"
      expect(page).to have_content rating2.to_s + " Harrastelija"
    end
    
    it "is shown in user's own list of ratings" do
      visit user_path(user.id)
      
      expect(page).to have_content "Has made 1 rating"
      expect(page).to have_content rating1.to_s
      expect(page).to_not have_content rating2.to_s
    end
    
    it "is deleted correctly" do
      visit user_path(user.id)
      
      expect {
        click_link "delete"
      }.to change{user.ratings.count}.from(1).to(0)
    end
  end
end