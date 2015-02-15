class Beer < ActiveRecord::Base
  include RatingAverage

  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  validates :name, presence: true
  validates :style, presence: true

  #def average
  #  return 0 if ratings.empty?
  #  ratings.map{ |r| r.score }.sum / ratings.count.to_f
  #end
  def to_s
    "#{name} #{brewery.name}"
    #return name + " (#{brewery.name})"
  end
end
