module UsersHelper
  def display_name(user)
    user.username.presence || user.email
  end

  def display_email(user)
    if user.provider == "facebook" &&
       user.email.present? &&
       user.email.start_with?("facebook-") &&
       user.email.end_with?("@example.com")
      I18n.t("users.email.signed_in_with_facebook")
    else
      user.email
    end
  end

  def avatar_for(user, size: 96)
    if user.avatar.attached?
      image_tag user.avatar.variant(resize_to_fill: [size, size]),
                alt: display_name(user),
                class: "rounded-full border"

    elsif user.provider == "facebook" && user.uid.present?
      fb_url = "https://graph.facebook.com/#{user.uid}/picture?type=large"
      image_tag fb_url,
                width: size,
                height: size,
                class: "rounded-full object-cover",
                alt: user.username
    else
      content_tag :div, display_name(user)[0].upcase,
                  class: "rounded-full border flex items-center justify-center",
                  style: "width:#{size}px;height:#{size}px;"
    end
  end
end
