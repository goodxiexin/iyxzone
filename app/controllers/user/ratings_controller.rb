class User::RatingsController < UserBaseController

  def create
    @rating = @rateable.ratings.create params[:rating]

    if @rating.save
      render :json => {:code => 1, :average_rating => @rating.rateable.average_rating}
    else
      render :json => {:code => 0}
    end
  end

protected

  def setup
    @rateable = params[:rateable_type].camelize.constantize.find params[:rateable_id]
  end

end
