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

  def favorite_style
    return nil if ratings.empty?
    current_favorite = nil
    current_average = 0.0
    styles = ratings.group_by {|rating| rating.beer.style}
    for style in styles.keys
      temp_sum = 0.0
      temp_count = 0.0
      for rating in styles[style]
        temp_sum = temp_sum + rating.score
        temp_count = temp_count + 1.0
      end
      if (temp_sum / temp_count > current_average)
        current_favorite = style
        current_average = temp_sum / temp_count
      end
    end
    return current_favorite
  end

  def favorite_brewery
    return nil if ratings.empty?
    current_favorite = nil
    current_average = 0.0
    breweries = ratings.group_by {|rating| rating.beer.brewery.id}
    for brewery in breweries.keys
      temp_sum = 0.0
      temp_count = 0.0
      for rating in breweries[brewery]
        temp_sum = temp_sum + rating.score
        temp_count = temp_count + 1.0
      end
      if (temp_sum / temp_count > current_average)
        current_favorite = brewery
        current_average = temp_sum / temp_count
      end
    end
    return Brewery.find_by id: current_favorite
  end

end
