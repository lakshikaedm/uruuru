require "rails_helper"

RSpec.describe "Recruiter demo login", type: :system do
  before do
    create(:user, email: "recruiter@example.com", username: "Recruiter Demo")
  end

  it "logs in recruiter via navbar button" do
    visit root_path

    expect(page).to have_button(I18n.t("navbar.recruiter_demo_login"))

    click_button I18n.t("navbar.recruiter_demo_login"), match: :first

    expect(page).to have_current_path(root_path)
    expect(page).to have_content("Recruiter Demo")
  end
end
