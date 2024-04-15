class Video < ApplicationRecord
  scope :uncaptioned, -> { where(captions: false) }

  def download_url
    "https://#{Rails.application.credentials.dig(:bunny, :zone)}.b-cdn.net/#{guid}/play_240p.mp4"
  end
end
