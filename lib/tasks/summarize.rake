# frozen_string_literal: true

namespace :summarizer do
  desc 'This task reads input json file of employees workload period and ' \
    'outputs summary of a given period'
  task :execute, [:file_path] do |_, args|
    file = File.read(args[:file_path])

    input_data = JSON.parse(file, symbolize_names: true)

    output_data = Services::Summarizer.new(input_data).execute

    puts output_data.to_json
  end
end
