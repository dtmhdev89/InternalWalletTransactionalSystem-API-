class PingJob
  include Sidekiq::Job
  include Sidekiq::Status::Worker

  def perform(*args)
    p "pong"
  end
end
