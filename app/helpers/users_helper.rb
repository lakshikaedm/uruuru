module UsersHelper
  def display_name(user)
    user.username.presence || user.email
  end

  def avatar_for(user, size: 96)
    if user.avatar.attached?
      image_tag user.avatar.variant(resize_to_fill: [size, size]),
                alt: display_name(user),
                class: "rounded-full border"
    else
      content_tag :div, display_name(user)[0].upcase,
                  class: "rounded-full border flex items-center justify-center",
                  style: "width:#{size}px;height:#{size}px;"
    end
  end
end
