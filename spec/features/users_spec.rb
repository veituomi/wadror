require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end
    
    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end
  
  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end
  
  describe "has favorite" do
    let!(:user) { FactoryGirl.create :user2 }
    let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
    let!(:beer) { FactoryGirl.create :beer_ipa, name:"iso 3", brewery:brewery }
    let!(:rating) { FactoryGirl.create :rating, score:15, beer:beer, user:user }
    
    before :each do
      visit user_path(user.id)
    end
    
    it "style shown" do
      expect(page).to have_content("favorite style: IPA")
    end
    it "brewery shown" do
      expect(page).to have_content("favorite brewery: Koff")
    end
  end
end