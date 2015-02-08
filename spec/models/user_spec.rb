require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user) { FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  it "is not saved with too short a password" do
    user = User.create username: "Pekka", password: "p1", password_confirmation: "p1"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a password consisting only of letters" do
    user = User.create username: "Pekka", password: "abcd", password_confirmation: "abcd"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "favorite beer" do
    let(:user) { FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).respond_to? :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user) { FactoryGirl.create(:user) }
    it "has method for determining one" do
      expect(user).respond_to? :favorite_style
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer: beer, user: user)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one with highest ratings if several rated" do
      beer1 = FactoryGirl.create(:beer, style: "Style1")
      beer2 = FactoryGirl.create(:beer, style: "Style2")
      create_ratings_for_beer(1, 2, 3, beer1, user)
      create_ratings_for_beer(4, 5, 6, beer2, user)
      expect(user.favorite_style).to eq(beer2.style)
    end
  end
  describe "favorite brewery" do
    let(:user) { FactoryGirl.create(:user) }
    it "has method for determining one" do
      expect(user).respond_to? :favorite_brewery
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer: beer, user: user)

      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the one with highest ratings if several rated" do
      brewery1 = FactoryGirl.create(:brewery, name: "Brewery1")
      brewery2 = FactoryGirl.create(:brewery, name: "Brewery2")
      beer1 = FactoryGirl.create(:beer, brewery: brewery1)
      beer2 = FactoryGirl.create(:beer, brewery: brewery2)
      create_ratings_for_beer(1, 2, 3, beer1, user)
      create_ratings_for_beer(4, 5, 6, beer2, user)
      expect(user.favorite_brewery).to eq(beer2.brewery)
    end
  end

end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end
end

def create_beer_with_rating(score, user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score: score, beer: beer, user: user)
  beer
end
