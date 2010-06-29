require 'all_your_base'
require 'all_your_base/are/belong_to_us'

class MiniLink < ActiveRecord::Base

  def compressed_id
    id.to_base_62
  end

end
