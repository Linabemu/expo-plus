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
  user1 = User.create!(email: 'test@test.com', username: 'Cyril', password: 'azerty', description: "Passionné par la photo, j'adore shiner de nouveaux vernissages le weekend")

  user2 = User.create!(email: 'test2@test.com', username: 'Jules', password: 'azerty')

  user3 = User.create!(email: 'test3@test.com', username: 'Marine', password: 'azerty')

  user4 = User.create!(email: 'test4@test.com', username: 'Lina', password: 'azerty')

  user5 = User.create!(email: 'test5@test.com', username: 'Naomi', password: 'azerty', description: "L'art illumine ma vie depuis toujours. Abonnez-vous pour suivre les meilleures tendances à Paris")

  user6 = User.create!(email: 'test6@test.com', username: 'Tanguy', password: 'azerty', description: "Je suis quelqu'un de très gentil qui aime faire de nouvelle rencontre pendant une expo. Alors la prochaine fois viens, tu vas voir, on sera bien, même bien bien bien ;)")


  user1.photo.attach(io: URI.open("https://avatars.githubusercontent.com/u/102356829?v=4"), filename: "#{user1.username}.png")

  user2.photo.attach(io: URI.open("https://avatars.githubusercontent.com/u/103044146?v=4"), filename: "#{user2.username}.png")

  user3.photo.attach(io: URI.open("https://avatars.githubusercontent.com/u/61592567?v=4"), filename: "#{user3.username}.png")

  user4.photo.attach(io: URI.open("https://avatars.githubusercontent.com/u/101411883?v=4"), filename: "#{user4.username}.png")

  user5.photo.attach(io: URI.open("https://static.wikia.nocookie.net/lemondededisney/images/a/a5/Naomi_Scott.jpg/revision/latest?cb=20200328144051&path-prefix=fr"), filename: "#{user3.username}.png")

  user6.photo.attach(io: URI.open("https://media.istockphoto.com/photos/smiling-businessman-looking-into-camera-picture-id503344335?k=20&m=503344335&s=612x612&w=0&h=DNdR9YcFjq0HgHaJnU3dlGIzqKFpocl4D7Bbtf8Z1vU="), filename: "#{user4.username}.png")

  puts "Users created"


  puts "Parsing the API..."
  url = "https://opendata.paris.fr/api/records/1.0/search/?dataset=que-faire-a-paris-&q=&rows=1000&facet=date_start&facet=date_end&facet=tags&facet=address_name&facet=address_zipcode&facet=address_city&facet=pmr&facet=blind&facet=deaf&facet=transport&facet=price_type&facet=access_type&facet=updated_at&facet=programs&refine.tags=Expo"
  serialized_records = URI.open(url).read
  records = JSON.parse(serialized_records)["records"]
  puts "API parsed"


  puts "Creating expos…"

  records.take(30).each do |record|

    if record["fields"]["address_name"].nil? || record["fields"]["address_street"].nil? || record["fields"]["address_city"].nil? || record["fields"]["address_zipcode"].nil? || record["geometry"]["coordinates"][1].nil? || record["geometry"]["coordinates"][0].nil? || record["fields"]["address_name"].nil?
      next
    end

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


expo_one = Expo.all.where(title: 'CINÉMA MON AMOUR - LES ANNÉES STUDIO')
expo_two = Expo.all.where(title: 'Rencontre avec les éditions Maison Eliza')
expo_three = Expo.all.where(title: 'Carte Blanche 13 bis X Roger-Viollet')
expo_four = Expo.all.where(title: "Les ressources du Grand Paris sublimées au Pavillon de l'Arsenal")
expo_five = Expo.all.where(title: "Musée")
expo_six = Expo.all.where(title: "Avec « Desmemoria », Laetitia Tura donne à voir l’exil et sa mémoire, hier et aujourd’hui")
expo_seven = Expo.all.where(title: "Exposition : A portée de train")
expo_height = Expo.all.where(title: "Visite guidée de l’exposition « Silsila, le voyage des regards")
expo_nine = Expo.all.where(title: "Radomir MILOVIĆ peintures - Galerie Boris")
expo_ten = Expo.all.where(title: "Exposition \"Invitation au voyage\"")
expo_eleven = Expo.all.where(title: "Toucher le feu. Femmes céramistes au Japon")
expo_twelve = Expo.all.where(title: "DINH Q. LÊ Le fil de la mémoire et autres photographies")
expo_thirteen = Expo.all.where(title: "Les Heures Sauvages")
expo_fourteen = Expo.all.where(title: "PLANÈTE Z - Exposition de Jeanne Frank")
expo_fifteen = Expo.all.where(title: "SOPHIE CALLE et son invité Jean-Paul Demoule - Les fantômes d'Orsay")
expo_sixteen = Expo.all.where(title: "Trouble dans le portrait : une exposition de Christophe Beauregard")
expo_seventeen = Expo.all.where(title: "Exposition 'Héroïnes romantiques'")
expo_eighteen = Expo.all.where(title: "Exposition « Silsila, le voyage des regards » à l'ICI")
expo_nineteen = Expo.all.where(title: "Les visites ateliers photographiques de la MEP")
expo_twenty = Expo.all.where(title: "Visite guidée des collections permanentes du musée Cernuschi")

expo_twenty_one = Expo.all.where(title: "Atelier kombucha par Vivien Roussel, artiste, biodesigner et chercheur")
expo_twenty_two = Expo.all.where(title: "Visite-soupe en compagnie de l'artiste Tiphaine Calmettes")
expo_twenty_three = Expo.all.where(title: "Radio Daisy")
expo_twenty_four = Expo.all.where(title: "« Taste Korea ! 2022 » Au cœur de la culture bouddhique coréenne")
expo_twenty_five = Expo.all.where(title: "Exposition / Drawing An Aspiration - Charwei Tsai")
expo_twenty_six = Expo.all.where(title: "L’horizon de Khéops, \"Un voyage en Egypte ancienne\"")

expo_twenty_seven = Expo.all.where(title: "Exposition \"Invitation au voyage\"")
expo_twenty_eight = Expo.all.where(title: "Dé(s)compositions Alchimiques, atelier 6-12 ans")
expo_twenty_nine = Expo.all.where(title: "Assemblage-paysage, un atelier pour toutes et tous")
expo_thirty = Expo.all.where(title: "L’AVENTURE CHAMPOLLION, Dans le secret des hiéroglyphes")
expo_thirty_one = Expo.all.where(title: "Exposition Garo 1964-1974, une histoire dans l'Histoire")


puts 'variables ok'

puts '2'
expo_two.update!(title: "les éditions Maison Eliza",
                tags: ["photo"])



puts '3'
expo_three.update!(title: "13 bis X Roger-Viollet",
                  tags: ["photo"])

puts '4'
expo_four.update!(title: "Les ressources du Grand Paris",
                  tags: ["art contemporain"])

# puts '5'
# expo_five.destroy

puts '6'
expo_six.update!(title: "Desmemoria",
                 tags: ["histoire", "voyages"])

puts '7'
expo_seven.update!(title: "A portée de train",
                   tags: ["sciences et techniques", "voyages"])

puts '9'
expo_nine.update!(title: "Radomir Milovic",
                  tags: ["art contemporain", "beaux-arts"])

puts '10'
expo_ten.update!(title: "Invitation au voyage",
                 tags: ["voyages", "beaux-arts"])

# expo_eleven.update!(title: "")

puts '12'
expo_twelve.update!(title: "DINH Q",
                    tags: ["voyages", "histoire", "photo"])

puts '13'
expo_thirteen.update!(title: "Les Heures Sauvages",
                      tags: ["art contemporain"])

puts '14'
expo_fourteen.update!(title: "Planète Z",
                      tags: ["art contemporain"])

puts '15'
expo_fifteen.update!(title: "Les fantômes d'Orsay",
                     tags: ["art contemporain", "photo"])

puts '16'
expo_sixteen.update!(title: "Trouble dans le portrait",
                     tags: ["art contemporain", "photo"])

puts '17'
expo_seventeen.update!(title: "Héroïnes romantiques",
                       tags: ["beaux-arts"])

puts '18'
expo_eighteen.update!(title: "Silsila",
                      tags: ["beaux-arts", "voyages", "histoire"])

# puts '19'
# expo_nineteen.destroy

# puts '20'
# expo_twenty.destroy

puts '21'
expo_twenty_one.update!(title: "Vivien Roussel",
                        tags: ["art contemporain"])

puts '22'
expo_twenty_two.update!(title: "Soupe Primordiale",
                        tags: ["art contemporain"])

puts '23'
expo_twenty_three.update!(title: "Radio Daisy",
                           tags: ["art contemporain", "beaux-arts"])

puts '24'
expo_twenty_four.update!(title: "Taste Korea 2022",
                         tags: ["art contemporain", "voyages"])

puts '25'
expo_twenty_five.update!(title: "Charwei Tsai",
                        tags: ["art contemporain", "beaux-arts"])

puts '26'
expo_twenty_six.update!(title: "L’horizon de Khéops",
                        tags: ["histoire", "beaux-arts"])

puts '27'
expo_twenty_seven.update!(title: "Invitation au voyage",
                          tags: ["art contemporain", "voyages"])

expo_twenty_eight.update!(title: "Dé(s)compositions Alchimiques",
                          tags: ["art contemporain", "sciences et techniques"])

# expo_twenty_nine.destroy

expo_thirty.update!(title: "L'Aventure Champollion",
                    tags: ["histoire", "beaux-arts"])

expo_thirty_one.update!(title: "Garo 1964-1974",
                        tags: ["voyages", "beaux-arts"])




Review.create(rating: 4, comment: "la meilleure expo de l'année", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 5, comment: "trop beau !!!", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 2, comment: "Je n'ai pas aimé du tout :(", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 5, comment: "j'ai adoré", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 4, comment: "Bravo !", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 3, comment: "Super, magnifique ! Bravo à toute l'équipe !", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 1, comment: "Pas terrible", user: User.all.sample, expo: Expo.all.sample)
Review.create(rating: 4, comment: "la meilleure expo de l'année", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 4, comment: "trop beau !!!", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 5, comment: "Waouh, des étoiles plein les yeux", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 5, comment: "j'ai adoré", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 4, comment: "Bravo !", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 3, comment: "Super", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 3, comment: "C'était top", user: User.all.sample, expo: Expo.all.sample)
Review.create(rating: 4, comment: "la meilleure expo de l'année", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 5, comment: "trop beau !!!", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 3, comment: "Bonne expo", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 5, comment: "j'ai adoré", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 4, comment: "Bravo !", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 3, comment: "Super", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 5, comment: "Waouh", user: User.all.sample, expo: Expo.all.sample)
Review.create(rating: 4, comment: "la meilleure expo de l'année", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 4, comment: "trop beau !!!", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 5, comment: "C'était magique <3", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 5, comment: "j'ai adoré", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 4, comment: "Bravo !", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 3, comment: "Super", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 3, comment: "Bravo", user: User.all.sample, expo: Expo.all.sample)
Review.create(rating: 4, comment: "la meilleure expo de l'année", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 5, comment: "trop beau !!!", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 3, comment: "Bonne expo", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 5, comment: "j'ai adoré", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 4, comment: "Bravo !", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 3, comment: "Super", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 5, comment: "Waouh", user: User.all.sample, expo: Expo.all.sample)
Review.create(rating: 4, comment: "la meilleure expo de l'année", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 4, comment: "trop beau !!!", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 5, comment: "C'était magique <3", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 5, comment: "j'ai adoré", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 4, comment: "Bravo !", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 3, comment: "Super", user: User.all.sample, expo: Expo.all.sample)
Review.create!(rating: 3, comment: "Bravo", user: User.all.sample, expo: Expo.all.sample)
puts "Reviews OK"
