module Video::VideosHelper

  def video_link video
    link_to (truncate video.title, :length => 20), video_url(video)
  end


end
