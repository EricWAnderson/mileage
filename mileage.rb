require 'csv'
require 'optparse'
require 'ostruct'
require './auto_seeker'

data = CSV.read('foobarnian_autos.csv')

options = OpenStruct.new
OptionParser.new do |opt|
  opt.on('-c', '--color COLOR', 'Car color (example: Red)') { |o| options[:color] = o }
  opt.on('-f', '--fuel FUEL', 'Fuel type (example: gas)') { |o| options[:fuel] = o }
  opt.on('-x', '--max MAX_PRICE', 'Maximum car price (example: 20000)') { |o| options[:max_price] = o }
  opt.on('-m', '--min MIN_PRICE', 'Minimum car price (example: 15000)') { |o| options[:min_price] = o }
end.parse!

seeker = AutoSeeker.new data

autos = seeker.filter(:color, options.color) if options.color
autos = seeker.filter(:fuel, options.fuel) if options.fuel
autos = seeker.filter(:max_price, options.max_price) if options.max_price
autos = seeker.filter(:min_price, options.min_price) if options.min_price

if autos.length.zero?
  abort "no autos with the selected options found: #{options}"
end

mileage = AutoSeeker.median_mileage(autos)

puts "median mileage = #{mileage} MPG"
