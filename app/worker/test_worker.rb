# frozen_string_literal: true

class TestWorker
  include Sidekiq::Worker

  def perform
    time = Time.zone.now.to_s

    sleep(40)

    TestMailer.excute(time).deliver_later
  end
end
