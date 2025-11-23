require "rails_helper"

RSpec.describe "Profile", type: :system do
  let!(:user) { create(:user, username: "User1") }

  it "links from navbar to profile" do
    sign_in user
    visit root_path
    within("nav") do
      click_link "User1", match: :first
    end
    expect(page).to have_current_path(profile_path)
    expect(page).to have_content("User1")
    expect(page).to have_link("❤️ Favorites", href: favorites_path)
  end
end
