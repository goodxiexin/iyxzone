class RatingObserver < ActiveRecord::Observer

  def after_save rating
    # reset average
    rateable = rating.rateable
    rateable.update_attribute('average_rating', rateable.ratings.average(:rating))  
  end

  def after_create rating
    rating.rateable.raw_increment :ratings_count
  end

end
