# frozen_string_literal: true

class WorkPeriod
  attr_reader :start_date, :end_date, :employees

  def initialize(args)
    @start_date = args.fetch(:start_date)
    @end_date = args.fetch(:end_date)
    @employees = args.fetch(:employees)
  end
end
