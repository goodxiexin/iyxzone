class InvalidName < ActiveRecord::Base

  validates_uniqueness_of :user_id

  validates_presence_of :user_id

  belongs_to :user

  before_save :make_token

protected

  def make_token
    self.token = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

end
