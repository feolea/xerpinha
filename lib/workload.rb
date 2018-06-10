# frozen_string_literal: true

class Workload
  attr_reader :days, :daily_workload_time, :daily_minimum_rest_interval

  def initialize(args)
    @days = args.fetch(:days)
    @daily_workload_time = args.fetch(:daily_workload_time)
    @daily_minimum_rest_interval = args.fetch(:daily_minimum_rest_interval)
  end
end
