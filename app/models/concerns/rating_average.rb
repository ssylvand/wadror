module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    # return ratings.inject(0.0) { |sum, rating| sum + rating.score } / ratings.length
    return 0 if ratings.empty?
    ratings.map(&:score).sum.to_f/ratings.count
  end
end