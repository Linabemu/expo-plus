# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'json'
require 'open-uri'

puts "Destroying all records ..."
Message.destroy_all
Place.destroy_all
Expo.destroy_all
Review.destroy_all
Proposal.destroy_all
Wish.destroy_all
Participant.destroy_all
User.destroy_all
Following.destroy_all
puts "Destroyed DB"

puts "Creating users…"
user1 = User.create!(email: 'test@test.com', username: 'Cyril', password: 'azerty')
user2 = User.create!(email: 'test2@test.com', username: 'Jules', password: 'azerty')
user3 = User.create!(email: 'test3@test.com', username: 'Marine', password: 'azerty')
user4 = User.create!(email: 'test4@test.com', username: 'Lina', password: 'azerty')

user1.photo.attach(io: URI.open("https://avatars.githubusercontent.com/u/102356829?v=4"), filename: "#{user1.username}.png")
user2.photo.attach(io: URI.open("https://avatars.githubusercontent.com/u/103044146?v=4"), filename: "#{user2.username}.png")
user3.photo.attach(io: URI.open("https://avatars.githubusercontent.com/u/61592567?v=4"), filename: "#{user3.username}.png")
user4.photo.attach(io: URI.open("https://avatars.githubusercontent.com/u/101411883?v=4"), filename: "#{user4.username}.png")
puts "Users created"


puts "Parsing the API..."
url = "https://opendata.paris.fr/api/records/1.0/search/?dataset=que-faire-a-paris-&q=&rows=1000&facet=date_start&facet=date_end&facet=tags&facet=address_name&facet=address_zipcode&facet=address_city&facet=pmr&facet=blind&facet=deaf&facet=transport&facet=price_type&facet=access_type&facet=updated_at&facet=programs&refine.tags=Expo"
serialized_records = URI.open(url).read
records = JSON.parse(serialized_records)["records"]
puts "API parsed"


puts "Creating expos…"

records.take(20).each do |record|

  expo = Expo.new(
          api_records_id: record["fields"]["id"],
          api_updated_at: record["fields"]["updated_at"],
          title: record["fields"]["title"],
          lead_text: record["fields"]["lead_text"],
          description: record["fields"]["description"].gsub(/<img[^>]*?>.*<\/img>/,""),
          tags: record["fields"]["tags"].split(Regexp.union(["_",";"])),
          cover_url: record["fields"]["cover_url"],
          cover_alt: record["fields"]["cover_alt"],
          cover_credit: record["fields"]["cover_credit"],
          date_start: record["fields"]["date_start"],
          date_end: record["fields"]["date_end"],
          occurences: (record["fields"]["occurrences"].nil? ? [] : record["fields"]["occurrences"].split(Regexp.union(["_",";"]))),
          date_description: record["fields"]["date_description"],
          price_type: record["fields"]["price_type"],
          price_detail: record["fields"]["price_detail"],
          contact_url: record["fields"]["contact_url"]
        )

  expo.photo.attach(
    io: URI.open(expo.cover_url),
    filename: record["fields"]["image_couverture"]["filename"], # use the extension of the attached file here (found at the end of the url)
    content_type: record["fields"]["image_couverture"]["mimetype"]
  )

  if Place.where(address_name: record["fields"]["address_name"]).take.nil?
    place = Place.new(
      address_name: record["fields"]["address_name"],
      address_street: record["fields"]["address_street"],
      address_city: record["fields"]["address_city"],
      address_zipcode: record["fields"]["address_zipcode"],
      lat: record["geometry"]["coordinates"][1],
      lon: record["geometry"]["coordinates"][0],
      access_link: record["fields"]["address_name"]
    )

    place.save!
    puts "New place created : #{place.address_name}"
  else
    place = Place.where(address_name: record["fields"]["address_name"]).take
  end

  expo.place = place
  expo.save!

  puts "New expo created : #{expo.title}"
end

Review.create(rating: 7, comment: "la meilleure expo de l'année", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 10, comment: "trop beau !!!", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 1, comment: "nul nul nul", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 9, comment: "j'ai adoré", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 7, comment: "Bravo !", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 9, comment: "Super", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 4, comment: "Pas terrible", user: User.all.sample, expo: Expo.all.sample)
Review.create(rating: 7, comment: "la meilleure expo de l'année", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 10, comment: "trop beau !!!", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 1, comment: "nul nul nul", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 9, comment: "j'ai adoré", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 7, comment: "Bravo !", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 9, comment: "Super", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 4, comment: "Pas terrible", user: User.all.sample, expo: Expo.all.sample)
puts "Reviews OK"

puts "Creating followings"
Following.create!(user_id: user2.id, receiver_id: user1.id)
Following.create!(user_id: user3.id, receiver_id: user1.id)
Following.create!(user_id: user4.id, receiver_id: user1.id)

Following.create!(user_id: user1.id, receiver_id: user2.id)
Following.create!(user_id: user3.id, receiver_id: user2.id)
Following.create!(user_id: user4.id, receiver_id: user2.id)

Following.create!(user_id: user1.id, receiver_id: user3.id)
Following.create!(user_id: user2.id, receiver_id: user3.id)
Following.create!(user_id: user4.id, receiver_id: user3.id)

Following.create!(user_id: user1.id, receiver_id: user4.id)
Following.create!(user_id: user2.id, receiver_id: user4.id)
Following.create!(user_id: user3.id, receiver_id: user4.id)
puts "Followings created"

puts "creating proposals and participants"


User.all.each do |user|
  date_seed = "2022-07-30".to_time
  Proposal.create!(confirmed: false, max_participants: 4, user_id: user.id, expo_id: Expo.all.sample(1).first.id, description: "blablablablablablablabla puis aussi blablblablablabla I'm a god", date_proposale: date_seed)
end

User.all.each do |user|
  i = 0
  3.times do
    Participant.create!(user_id: user.id, proposal_id: Proposal.all.where.not(user: user)[i].id)
    i += 1
  end
end
puts "Proposals and participants created"




# New Seed
Place.create!(address_name: 'Musée de la Vie romantique, Hôtel Scheffer-Renan',
              address_street: '16 rue Chaptal',
              address_city: 'Paris',
              address_zipcode: '75009',
              lat: 48.8810988,
              lon: 2.33344769999997,
              access_link: 'mobilité réduite'
              )

Expo.create!(# api_records_id: '',
            # api_updated_at: '',
            title: 'Héroïnes romantiques',
            lead_text: 'Grâce à une sélection d’une centaine d’œuvres - peintures, sculptures, manuscrits et objets d’art - l’exposition du musée de la Vie romantique explore ces questions en invitant le public à découvrir des héroïnes revisitées ou inventées par les artistes de l’époque. Le parcours en trois temps présente successivement les héroïnes du passé, les héroïnes de fiction et les héroïnes en scène. L’exposition Héroïnes romantiques tisse par ailleurs des liens entre les Beaux-arts, la littérature et les arts de la scène qui jouent au XIXe siècle un rôle majeur dans la diffusion d’un héroïsme féminin aux accents tragiques.',
          #  description: '' ,
            tags: ['Peinture', 'Sculpture'],
            #  cover_url: '',
            #  cover_alt: '',
            #  cover_credit: '',
            date_start: '',
            date_end: '',
          #  occurences: '',
            date_description: '',
            price_type: '',
            #  price_detail: '',
            #  contact_url: '',
            place_id: '',



            )
