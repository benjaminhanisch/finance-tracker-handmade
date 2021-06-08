require 'json'
require 'byebug'
require 'httparty'
require 'rails'
require 'pry'

# dataset_name = "19-DFP-01"
# dataset_name = "18-GSK-02"
# dataset_name = "18-REM-01"
# dataset_name = "18-SPT-12"
# dataset_name = "20-ALG-01"
# dataset_name = "20-AST-01"
dataset_name = "20-CPL-01"
# dataset_name = "20-NAB-02"
# dataset_name = "20-PZR-01"
# dataset_name = "20-PZR-05"
# dataset_name = "20-SHI-01"
# dataset_name = "20-APX-03"
# dataset_name = "20-CID-01"

response = HTTParty.get("https://react.api.jmilabs.com/datasets/molecular_qualification?dataset=#{dataset_name}")
# response = HTTParty.get("http://localhost:3000/datasets/molecular_qualification?dataset=#{dataset_name}")

if response.blank?
  puts "The dataset contains no isolates"
  category_stamps = []
  File.write("/Users/ben/Desktop/Udemy_codings/complete_ruby_on_rails_course/rails_projects/finance-tracker/finance-tracker-handmade/lib/#{dataset_name}.rb", category_stamps)
  return
else
  publishing_sets = response.map{|x| x["publishingset"]}.uniq
  category_stamps = []
  publishing_sets.each do |ps|
    el = Hash.new
    el[:category_name] = "#{dataset_name} #{ps}"
    el[:criteria] = { collection_number: {include: (response.select{ |x| x["publishingset"] == ps }).map{ |x| x["collection_number"] }}}
    category_stamps << el
  end
  p category_stamps
  File.write("./#{dataset_name}.rb", category_stamps)
  category_stamps
end
