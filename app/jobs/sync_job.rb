class SyncJob < ApplicationJob
  def perform
    Bunny.new.sync
  end
end
