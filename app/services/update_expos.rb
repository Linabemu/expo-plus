class UpdateExpos
  def initialize()
  end

  def add_new
    require 'json'
    require 'open-uri'

    puts "Parsing the API..."
    url = "https://opendata.paris.fr/api/records/1.0/search/?dataset=que-faire-a-paris-&q=&rows=1000&facet=date_start&facet=date_end&facet=tags&facet=address_name&facet=address_zipcode&facet=address_city&facet=pmr&facet=blind&facet=deaf&facet=transport&facet=price_type&facet=access_type&facet=updated_at&facet=programs&refine.tags=Expo"
    serialized_records = URI.open(url).read
    records = JSON.parse(serialized_records)["records"]
    puts "API parsed"


    puts "Adding new expos…"
    records.each do |record|

      while Expo.where(api_records_id: record["fields"]["id"]).take.nil?
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
          io: URI.open("#{expo.cover_url}"),
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

      puts "DB updated"

    end

  end
end
