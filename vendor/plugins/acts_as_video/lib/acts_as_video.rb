# ActsAsVideo
require 'fivesix'
require 'youku'
require 'tudou'
require 'ku6'

module ActsAsVideo

	def self.included(base)
		base.extend ClassMethods
	end

	module ClassMethods
		
		def acts_as_video
			
			extend ActsAsVideo::SingletonMethods

			include ActsAsVideo::InstanceMethods

			before_create :setup_video_info

		end


	end

	module SingletonMethods
	end

	module InstanceMethods

		def type
			return Youku if Youku.identify_url(video_url)
			return Tudou if Tudou.identify_url(video_url)
      return FiveSix if FiveSix.identify_url(video_url)
			return Ku6	 if Ku6.identify_url(video_url)
		end

		def setup_video_info
			unless video_url.blank?
				video_type = self.type
				if video_type.blank?
					errors.add_to_base("不能识别的视频url")
          return false
					#raise ActsAsVideo::NotRecognizedURL
				else 
					video = video_type.new(self)
					self.embed_html = video.embed_html
					self.thumbnail_url = video.thumbnail_url
				end
			end
		end

	end

	class NotRecognizedURL < StandardError; end

end

ActiveRecord::Base.send(:include, ActsAsVideo)
