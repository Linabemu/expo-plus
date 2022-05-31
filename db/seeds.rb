# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'open-uri'
require 'json'


puts "Destroying all records ..."
Place.destroy_all
Expo.destroy_all
Review.destroy_all
Proposal.destroy_all
User.destroy_all
Message.destroy_all
Wish.destroy_all
Participant.destroy_all
Following.destroy_all
puts "Destroyed DB"


puts "Creating users…"
user1 = User.create!(email: 'test@test.com', username: 'Cyril', password: 'azerty')
user2 = User.create!(email: 'test2@test.com', username: 'Jules', password: 'azerty')
user3 = User.create!(email: 'test3@test.com', username: 'Marine', password: 'azerty')
user4 = User.create!(email: 'test4@test.com', username: 'Lina', password: 'azerty')
puts "Users created"

puts "Parsing of the API..."
url = "https://opendata.paris.fr/api/records/1.0/search/?dataset=que-faire-a-paris-&q=&rows=200&facet=date_start&facet=date_end&facet=tags&facet=address_name&facet=address_zipcode&facet=address_city&facet=pmr&facet=blind&facet=deaf&facet=transport&facet=price_type&facet=access_type&facet=updated_at&facet=programs&refine.tags=Expo"
records = JSON.parse(URI.open(url).read)["records"]
puts "API parsed"


# puts "Creating expos…"
# offer1 = Offer.new(
#   user: user1,
#   name: 'I will stand in the line for you!',
#   unit_price: 3500,
#   overview: "At the mall, at Pôle Emploi or in any other long administration line, I will queue for you anywhere! Try me!",
#   location: "40 Bd Haussmann, 75009 Paris",
#   category: "Other",
#   currency: 'EUR'
# )
# offer1.photo.attach(
#   io: URI.open('https://static.needhelp.fr/photojobbing/88-1599661181.jpeg'),
#   filename: 'anyname.jpg', # use the extension of the attached file here (found at the end of the url)
#   content_type: 'image/jpg'
#   )
# offer1.save!
