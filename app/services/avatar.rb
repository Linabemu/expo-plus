# essaie qui n'a pas marché, ce serait cool de comprendre avec un TA

class Avatar
  require 'cloudinary'
  require "cloudinary/helper"

  def initialize()
  end

  def self.show(user)
    include CloudinaryHelper
    include Cloudinary

    if user.photo.attached?
      return cl_image_tag(user.photo.key)
    else
      return image_tag('black_placeholder.jpg')
    end
  end
end
