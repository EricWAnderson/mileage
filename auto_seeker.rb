require './auto'

class AutoSeeker

  def initialize data
    @data = data
  end

  def filter key, match
    @autos = autos.select do |auto|
      case key
      when :color, :fuel
        auto.send(key) == match
      when :max_price
        auto.price.to_i < match.to_i
      when :min_price
        auto.price.to_i > match.to_i
      end
    end
  end

  def autos
    @autos ||= @data.map do |row|
      Auto.new(row)
    end
  end

  def self.median_mileage autos
    prices = autos.reject { |auto| auto.mileage.nil? }.collect(&:mileage).sort

    (prices[(prices.length - 1) / 2].to_f + prices[prices.length / 2].to_f) / 2.0
  end
end
