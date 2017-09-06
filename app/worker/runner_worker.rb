# frozen_string_literal: true

class RunnerWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(class_name, method, args = [])
    class_name = class_name.classify.safe_constantize
    class_name.send(method, *args)
  end
end
