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
end
