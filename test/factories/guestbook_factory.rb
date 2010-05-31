class GuestbookFactory

  def self.create cond={}
    default_cond = cond[:user_id].blank? ? {:user_id => UserFactory.create.id} : {}
    Factory.create :guestbook, default_cond.merge(cond) 
  end

end
