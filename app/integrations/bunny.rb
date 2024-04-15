class Bunny
  attr_reader :client

  def self.sync
    new.sync
  end

  def initialize(access_key: nil, library_id: nil)
    @access_key ||= Rails.application.credentials.dig(:bunny, :access_key)
    @library_id ||= Rails.application.credentials.dig(:bunny, :library_id)

    @client = BunnyClient.new(access_key: @access_key, library_id: @library_id)
  end

  def sync(page: 1, per_page: 1000)
    loop do
      response = client.videos(page: page, per_page: per_page)
      break if response[:items].empty?

      page += 1
      ApplicationRecord.transaction do
        response[:items].each { sync_video(_1) }
      end
    end
  end

  def sync_video(item)
    Video.where(guid: item[:guid]).first_or_initialize
    video.update(
      library_id: item[:videoLibrearyId],
      title: item[:title],
      captions: item[:captions].any?{ _1[:label] == "English" }
    )
  end
end
