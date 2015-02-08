require 'rails_helper'

describe "Beer club page" do
  it "should not have any before been created" do
    visit beer_clubs_path
    expect(page).to have_content 'Listing Beer Clubs'
    expect(page).to have_content 'Number of beer clubs: 0'

  end

  describe "when beer clubs exist" do
    it "lists the beer clubs and their total number" do
      @beer_clubs = ["Club 1", "Club 2", "Club 3"]
      @beer_clubs.each do |name|
        FactoryGirl.create(:beer_club, name: name)
      end
      visit beer_clubs_path

        expect(page).to have_content "Number of beer clubs: #{@beer_clubs.count}"
      @beer_clubs.each do |beer_club|
        expect(page).to have_content beer_club
      end
    end
  end
end