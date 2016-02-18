require 'rails_helper'

describe "Beer" do
  let!(:style) { FactoryGirl.create :style, name:"Lager" }
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "is added when a proper name is provided" do
    visit new_beer_path
    select('Koff', from:'beer[brewery_id]')
    select('Lager', from:'beer[style_id]')
    fill_in('beer[name]', with:'New beer')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end
  
  it "is not added when no name is provided" do
    visit new_beer_path
    select('Lager', from:'beer[style_id]')
    select('Koff', from:'beer[brewery_id]')
    fill_in('beer[name]', with:'')

    expect{
      click_button "Create Beer"
    }.to_not change{Beer.count}
    expect(page).to have_content "Name is too short"
  end
end