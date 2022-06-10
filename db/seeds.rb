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

  user5.photo.attach(io: URI.open("https://i.pinimg.com/originals/6b/89/06/6b89060747fefd42e1fabe3176ba2494.jpg"), filename: "#{user3.username}.png")

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


expo_one = Expo.all.find_by(title: 'CINÉMA MON AMOUR - LES ANNÉES STUDIO')
expo_two = Expo.all.find_by(title: 'Rencontre avec les éditions Maison Eliza')
expo_three = Expo.all.find_by(title: 'Carte Blanche 13 bis X Roger-Viollet')
expo_four = Expo.all.find_by(title: "Les ressources du Grand Paris sublimées au Pavillon de l'Arsenal")
expo_five = Expo.all.find_by(title: "Musée")
expo_six = Expo.all.find_by(title: "Avec « Desmemoria », Laetitia Tura donne à voir l’exil et sa mémoire, hier et aujourd’hui")
expo_seven = Expo.all.find_by(title: "Exposition : A portée de train")
expo_height = Expo.all.find_by(title: "Visite guidée de l’exposition « Silsila, le voyage des regards")
expo_nine = Expo.all.find_by(title: "Radomir MILOVIĆ peintures - Galerie Boris")
expo_ten = Expo.all.find_by(title: "Exposition \"Invitation au voyage\"")
expo_eleven = Expo.all.find_by(title: "Toucher le feu. Femmes céramistes au Japon")
expo_twelve = Expo.all.find_by(title: "DINH Q. LÊ Le fil de la mémoire et autres photographies")
expo_thirteen = Expo.all.find_by(title: "Les Heures Sauvages")
expo_fourteen = Expo.all.find_by(title: "PLANÈTE Z - Exposition de Jeanne Frank")
expo_fifteen = Expo.all.find_by(title: "SOPHIE CALLE et son invité Jean-Paul Demoule - Les fantômes d'Orsay")
expo_sixteen = Expo.all.find_by(title: "Trouble dans le portrait : une exposition de Christophe Beauregard")
expo_seventeen = Expo.all.find_by(title: "Exposition 'Héroïnes romantiques'")
expo_eighteen = Expo.all.find_by(title: "Exposition « Silsila, le voyage des regards » à l'ICI")
expo_nineteen = Expo.all.find_by(title: "Les visites ateliers photographiques de la MEP")
expo_twenty = Expo.all.find_by(title: "Visite guidée des collections permanentes du musée Cernuschi")

expo_twenty_one = Expo.all.find_by(title: "Atelier kombucha par Vivien Roussel, artiste, biodesigner et chercheur")
expo_twenty_two = Expo.all.find_by(title: "Visite-soupe en compagnie de l'artiste Tiphaine Calmettes")
expo_twenty_three = Expo.all.find_by(title: "Radio Daisy")
expo_twenty_four = Expo.all.find_by(title: "« Taste Korea ! 2022 » Au cœur de la culture bouddhique coréenne")
expo_twenty_five = Expo.all.find_by(title: "Exposition / Drawing An Aspiration - Charwei Tsai")
expo_twenty_six = Expo.all.find_by(title: "L’horizon de Khéops, \"Un voyage en Egypte ancienne\"")

expo_twenty_seven = Expo.all.find_by(title: "Exposition \"Invitation au voyage\"")
expo_twenty_eight = Expo.all.find_by(title: "Dé(s)compositions Alchimiques, atelier 6-12 ans")
expo_twenty_nine = Expo.all.find_by(title: "Assemblage-paysage, un atelier pour toutes et tous")
expo_thirty = Expo.all.find_by(title: "L’AVENTURE CHAMPOLLION, Dans le secret des hiéroglyphes")
expo_thirty_one = Expo.all.find_by(title: "Exposition Garo 1964-1974, une histoire dans l'Histoire")


puts 'variables ok'

puts '2'
expo_two&.update!(title: "les éditions Maison Eliza",
                tags: ["photo"])
expo_two&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654808345/Maison_Eliza_Porcelaine_ja1kqh.jpg"),
  filename: expo_two.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)


puts '3'
expo_three&.update!(title: "13 bis X Roger-Viollet",
                  tags: ["photo"])

puts '4'
expo_four&.update!(title: "Les ressources du Grand Paris",
                  tags: ["art contemporain"])
expo_four&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654808366/pav_arsenal_ressources-1_584ec_fjshhy.jpg"),
  filename: expo_four.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

# puts '5'
expo_five&.destroy

puts '6'
expo_six&.update!(title: "Desmemoria",
                 tags: ["histoire", "voyages"])
expo_six&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654789449/laetitia-tura_n0ijpa.jpg"),
  filename: expo_six.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

puts '7'
expo_seven&.update!(title: "A portée de train",
                   tags: ["sciences et techniques", "voyages"])
  expo_seven&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654851090/train_vvbrw5.png"),
  filename: expo_seven.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

puts '9'
expo_nine&.update!(title: "Radomir Milovic",
                  tags: ["art contemporain", "beaux-arts"])
expo_nine&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654790204/radomir-milovic_iepbqq.jpg"),
  filename: expo_nine.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

puts '10'
expo_ten&.update!(title: "Invitation au voyage",
                 tags: ["voyages", "beaux-arts"])
  expo_ten&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654808347/invit_voyage_mg_0054_bey1ma.jpg"),
  filename: expo_ten.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

# expo_eleven&.update!(title: "")

puts '12'
expo_twelve&.update!(title: "DINH Q",
                    tags: ["voyages", "histoire", "photo"])
expo_twelve&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654789413/dinh-q-le_w3frzo.jpg"),
  filename: expo_twelve.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

puts '13'
expo_thirteen&.update!(title: "Les Heures Sauvages",
                      tags: ["art contemporain"])
expo_thirteen&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654790158/Les-heures-sauvages_smjcrv.jpg"),
  filename: expo_thirteen.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

puts '14'
expo_fourteen&.update!(title: "Planète Z",
                      tags: ["art contemporain"])
expo_fourteen&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654790180/planete-z2_hyvkcq.jpg"),
  filename: expo_fourteen.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

puts '15'
expo_fifteen&.update!(title: "Les fantômes d'Orsay",
                     tags: ["art contemporain", "photo"])
  expo_fifteen&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654790250/sophie-calle_wmjrmy.jpg"),
  filename: expo_fifteen.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

puts '16'
expo_sixteen&.update!(title: "Trouble dans le portrait",
                     tags: ["art contemporain", "photo"])
  expo_sixteen&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654808323/C-Beauregard_A-8470243_cshrqu.jpg"),
  filename: expo_sixteen.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

puts '17'
expo_seventeen&.update!(title: "Héroïnes romantiques",
                       tags: ["beaux-arts"])
  expo_seventeen&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654789430/heroines-romantiques_b69ao2.jpg"),
  filename: expo_seventeen.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

puts '18'
expo_eighteen&.update!(title: "Silsila",
                      tags: ["beaux-arts", "voyages", "histoire"])
expo_eighteen&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654792241/Silsila_le_voyage_des_regards_c9djjj.jpg"),
  filename: expo_eighteen.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

# puts '19'
# expo_nineteen.destroy

# puts '20'
# expo_twenty.destroy

puts '21'
expo_twenty_one&.update!(title: "Vivien Roussel",
                        tags: ["art contemporain"])
expo_twenty_one&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654808202/vivian-roussel_b5_dzs5t9.jpg"),
  filename: expo_twenty_one.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

puts '22'
expo_twenty_two&.update!(title: "Soupe Primordiale",
                        tags: ["art contemporain"])
expo_twenty_two&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654808212/soupe_primordiale-3_bdksaz.jpg"),
  filename: expo_twenty_two.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

puts '23'
expo_twenty_three&.update!(title: "Radio Daisy",
                           tags: ["art contemporain", "beaux-arts"])
  expo_twenty_three&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654808389/radio-daisy_WEB_ekentt.webp"),
  filename: expo_twenty_three.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

puts '24'
expo_twenty_four&.update!(title: "Taste Korea 2022",
                         tags: ["art contemporain", "voyages"])
  expo_twenty_four&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654808245/korea_xcvz4m.png"),
  filename: expo_twenty_four.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

puts '25'
expo_twenty_five&.update!(title: "Charwei Tsai",
                        tags: ["art contemporain", "beaux-arts"])
expo_twenty_five&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654808285/Charwei-Tsai-Lotus-Mantra-II-2-1024x652_ujjykf.jpg"),
  filename: expo_twenty_five.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

puts '26'
expo_twenty_six&.update!(title: "L’horizon de Khéops",
                        tags: ["histoire", "beaux-arts"])
expo_twenty_six&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654808330/hor_wub9hl.jpg"),
  filename: expo_twenty_six.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

puts '27'
expo_twenty_seven&.update!(title: "Invitation au voyage",
                          tags: ["art contemporain", "voyages"])
expo_twenty_seven&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654808347/invit_voyage_mg_0054_bey1ma.jpg"),
  filename: expo_twenty_seven.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

expo_twenty_eight&.update!(title: "Dé(s)compositions Alchimiques",
                          tags: ["art contemporain", "sciences et techniques"])
expo_twenty_eight&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654808328/descompositions_alchimiques1lyfxc7_qetyg8.jpg"),
  filename: expo_twenty_eight.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

# expo_twenty_nine.destroy

expo_thirty&.update!(title: "L'Aventure Champollion",
                    tags: ["histoire", "beaux-arts"])
expo_thirty&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654808295/Champollion_7vzy3g_pj3ot6.jpg"),
  filename: expo_thirty.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)

expo_thirty_one&.update!(title: "Garo 1964-1974",
                        tags: ["voyages", "beaux-arts"])
expo_thirty_one&.photo&.attach(
  io: URI.open("https://res.cloudinary.com/dpaxgliqd/image/upload/v1654808318/garo-couv-2_vedegw.jpg"),
  filename: expo_thirty_one.title, # use the extension of the attached file here (found at the end of the url)
  content_type: "jpg"
)




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
