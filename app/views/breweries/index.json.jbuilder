json.array!(@breweries) do |brewery|
  json.extract! brewery, :id, :name, :year
  json.beer_count brewery.beers.count
  json.url brewery_url(brewery, format: :json)
end
