# frozen_string_literal: true

class Employee
  attr_reader :name, :pis, :workload, :entries

  def initialize(args)
    @name = args.fetch(:name)
    @pis = args.fetch(:pis)
    @workload = args[:workload]
    @entries = args[:entries]
  end
end
