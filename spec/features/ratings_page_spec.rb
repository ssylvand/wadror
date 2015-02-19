require 'rails_helper'
include OwnTestHelper

describe "Ratings page" do
  let!(:brewery) { FactoryGirl.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name: "iso 3", brewery: brewery }
  let!(:beer2) { FactoryGirl.create :beer, name: "Karhu", brewery: brewery }
  let!(:user) { FactoryGirl.create :user }

  it "should not have any before been created" do
    visit ratings_path
    expect(page).to have_content 'All ratings'
    expect(page).to have_content 'Number of ratings: 0'
  end
  describe "when ratings exist" do
    it "lists the ratings and their total number" do
      create_ratings_for_beer(10, 3, 15, beer1, user)
      create_ratings_for_beer(20, 6, 30, beer2, user)
      ratings = Rating.all
      visit ratings_path
      expect(page).to have_content "Number of ratings: #{ratings.count}"
    end
  end
end

