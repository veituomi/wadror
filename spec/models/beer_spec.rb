require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is saved if a name and style are given" do
    beer = Beer.create name:"Test beer", style:"Valid style"
    
    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end
  
  describe "is not saved without" do
    it "name" do
      beer = Beer.create style:"Valid style"
      
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
    
    it "style" do
      beer = Beer.create name:"Valid name"
      
      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end
end
