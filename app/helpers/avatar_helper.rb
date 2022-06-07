module AvatarHelper
  def avatar(user)
    if user.photo.attached?
      return cl_image_tag(user.photo.key)
    else
      return image_tag('black_placeholder.jpg')
    end
  end
end
