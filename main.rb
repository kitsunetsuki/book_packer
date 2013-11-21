require 'json'
require_relative "sort"

shipment = Boxes.new(10)
puts shipment.boxes.to_json