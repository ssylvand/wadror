require 'rails_helper'
include OwnTestHelper

describe "User's ratings" do
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

  it "are displayed on user's page without showing ratings from anyone else" do
    expect(page).to have_content "has made #{user.ratings.count} ratings"
  end

  it "are deleted from the database when user deletes them" do
    ratings_count = user.ratings.count
    rating_text = user.ratings[0].beer.name
    find(:xpath, "(//a[text()='delete'])[1]").click
    expect(ratings_count).to eq(user.ratings.count + 1)
  end
end

