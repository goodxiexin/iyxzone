class PersonalAlbumFactory

  def self.create opts={}
    if opts[:owner_id].nil?
      user = UserFactory.create
      opts[:owner_id] = user.id
    else
      user = User.find(opts[:owner_id])
    end

    Factory.create :personal_album, opts
  end

end
