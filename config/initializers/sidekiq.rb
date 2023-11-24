if defined?(Sidekiq) && ENV["REDIS_HOST"] && ENV["REDIS_PORT"]
  redis_db = ENV["REDIS_DB"]

  redis_url = "redis://#{ENV["REDIS_HOST"]}:#{ENV["REDIS_PORT"]}/#{redis_db}"

  Sidekiq.configure_server do |config|
    config.redis = { url: redis_url }

    Sidekiq::Status.configure_server_middleware config, expiration: 7200
    Sidekiq::Status.configure_client_middleware config, expiration: 7200
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: redis_url }

    Sidekiq::Status.configure_client_middleware config, expiration: 7200
  end
end
