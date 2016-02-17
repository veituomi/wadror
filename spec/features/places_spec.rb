require 'rails_helper'

describe "Places" do
  describe "in case of cache miss" do
      before :each do
        Rails.cache.clear
      end

    it "if nothing is returned by the API, the corresponding message is shown" do
      allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
        []
      )
    
      visit places_path
      fill_in('city', with: 'kumpula')
      click_button "Search"
  
      expect(page).to have_content "No locations in kumpula"
    end
    
    it "if one is returned by the API, it is shown at the page" do
      allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
        [ Place.new( name:"Oljenkorsi", id: 1 ) ]
      )
  
      visit places_path
      fill_in('city', with: 'kumpula')
      click_button "Search"
  
      expect(page).to have_content "Oljenkorsi"
    end
    
    it "if several are returned by the API, they are all shown at the page" do
      allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
        [ Place.new( name:"Oljenkorsi", id: 1 ),
      Place.new( name:"Toinen baari", id: 2 ) ]
      )
    
      visit places_path
      fill_in('city', with: 'kumpula')
      click_button "Search"
  
      expect(page).to have_content "Oljenkorsi"
      expect(page).to have_content "Toinen baari"
    end
  end
  
  describe "in case of cache hit" do
  
    it "When one entry in cache, it is returned" do
      canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>13307</id><name>O'Connell's Irish Bar</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=13307</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=13307&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=13307&amp;d=1&amp;type=norm</blogmap><street>Rautatienkatu 24</street><city>Tampere</city><state></state><zip>33100</zip><country>Finland</country><phone>35832227032</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: {'Content-Type' => "text/xml"})

      # ensure that data found in cache
      BeermappingApi.places_in("espoo")

      places = BeermappingApi.places_in("espoo")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("O'Connell's Irish Bar")
      expect(place.street).to eq("Rautatienkatu 24")
    end
  end
end