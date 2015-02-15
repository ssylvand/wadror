require 'rails_helper'
include OwnTestHelper

describe "User's page" do
  let!(:brewery) { FactoryGirl.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name: "iso 3", brewery: brewery }
  let!(:beer2) { FactoryGirl.create :beer, name: "Karhu", brewery: brewery }
  let!(:user) { FactoryGirl.create :user }
  let!(:user2) { FactoryGirl.create :user, username: "Pekka2" }

  before :each do
    create_ratings_for_beer(10, 3, 15, beer1, user)
    create_ratings_for_beer(20, 6, 30, 40, beer2, user2)
    sign_in(username: "Pekka", password: "Foobar1")
    visit user_path(user)
  end

  it "displays user's favorite style" do
    expect(page).to have_content "Favorite style: #{beer2.style.style}"
  end

  it "displays user's favorite brewery" do
    expect(page).to have_content "Favorite brewery: #{beer2.brewery.name}"
  end
end

