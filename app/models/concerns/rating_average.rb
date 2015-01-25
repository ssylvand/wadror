module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return ratings.inject(0.0) { |sum, rating| sum + rating.score } / ratings.length
  end
end