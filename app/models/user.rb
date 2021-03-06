class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true,
            length: {in: 3..50}

  validates :password, length: {minimum: 4}

  validates :password, format: {with: /\d.*[A-Z]|[A-Z].*\d/, message: "has to contain one number and one upper case letter"}

  def self.top(n)
    sorted_by_number_of_ratings_in_desc_order = User.all.sort_by{ |u| -(u.ratings.count||0) }
    return sorted_by_number_of_ratings_in_desc_order.take(n)
  end

  def self.find_or_create_with_auth_hash(auth_hash)
    @user = User.find_by username: auth_hash.info.name
    if @user == nil
      generated_password = SecureRandom.uuid.upcase
      @user = User.new username: auth_hash.info.name, password: generated_password, password_confirmation: generated_password, admin: false, blocked: false
      @user.save

    end
    return @user
  end

  def favorite(category)
    return nil if ratings.empty?
    category_ratings = rated(category).inject([]) do |set, item|
      set << {
          item: item,
          rating: rating_of(category, item) }
    end

    category_ratings.sort_by { |item| item[:rating] }.last[:item]
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_brewery
    favorite :brewery
  end

  def favorite_style
    favorite :style
  end

  def rated(category)
    ratings.map { |r| r.beer.send(category) }.uniq
  end

  def rating_of(category, item)
    ratings_of_item = ratings.select do |r|
      r.beer.send(category) == item
    end
    ratings_of_item.map(&:score).sum / ratings_of_item.count
  end
end