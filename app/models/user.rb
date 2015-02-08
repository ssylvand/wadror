class User < ActiveRecord::Base
  include RatingAverage

  has_many :ratings, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
  has_many :beers, through: :ratings
  has_secure_password

  validates :username, uniqueness: true,
            length: {minimum: 3, maximum: 15}

  validates :password,
            length: {minimum: 4},
            format: {with: /^(?=.*\d)(?=.*[A-Z]).*$/, multiline: true, message: "needs to contain at least 1 capital letter and 1 digit"}

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end
end
