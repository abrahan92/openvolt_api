require "shrine"
require "shrine/storage/file_system"
require "shrine/storage/google_cloud_storage"

if Rails.env.production?
  Google::Cloud::Storage.configure do |config|
    config.project_id  = ENV['PROJECT_ID']
    config.credentials = "keys/gcp_auth_key.json"
  end

  Shrine.storages = {
    cache: Shrine::Storage::GoogleCloudStorage.new(bucket: ENV['IMAGE_STORAGE_BUCKET_NAME']),
    store: Shrine::Storage::GoogleCloudStorage.new(bucket: ENV['IMAGE_STORAGE_BUCKET_NAME']),
  }
else
  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads"),       # permanent
  }
end

Shrine.plugin :activerecord           # loads Active Record integration
Shrine.plugin :cached_attachment_data # enables retaining cached file across form redisplays
Shrine.plugin :restore_cached_data    # extracts metadata for assigned cached files