module Diggable

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def acts_as_diggable

      has_many :digs, :as => 'diggable', :dependent => :destroy

      include Diggable::InstanceMethods

      extend Diggable::SingletonMethods
    end   

  end

  module SingletonMethods
  end

  module InstanceMethods

		def digged_by? user
			digs.find_by_poster_id(user.id)
		end

  end

end

ActiveRecord::Base.send(:include, Diggable)

