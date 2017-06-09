require "minitest/autorun"
require "./auto_seeker"

describe AutoSeeker do
  before do
    data = [
      [1,'Red',12999,20.0,'gas'],
      [2,'Blue',13999,25.0,'gas'],
      [3,'Teal',19000,27.0,'gas'],
      [4,'Red',14999,40.0,'diesel'],
      [5,'Teal',15000,nil,'gas']
    ]
    @seeker = AutoSeeker.new data
  end

  describe "#filter " do
    it "can filter by color " do
      @seeker.filter :color, 'Red'
      @seeker.autos.collect(&:color).uniq.must_equal ['Red']
    end

    it "can filter by fuel type " do
      @seeker.filter :fuel, 'gas'
      @seeker.autos.collect(&:fuel).uniq.must_equal ['gas']
    end

    it "can filter by max price " do
      @seeker.filter :max_price, '18000'
      @seeker.autos.collect(&:price).must_equal [12999, 13999, 14999, 15000]
    end

    it "can filter by min price " do
      @seeker.filter :min_price, '18000'
      @seeker.autos.collect(&:price).must_equal [19000]
    end
  end

  describe ".median_mileage " do
    it "calculates median mileage for all autos" do
      AutoSeeker.median_mileage(@seeker.autos).must_equal 26.0
    end

    it "calculates median mileage for filtered autos" do
      @seeker.filter :color, 'Red'
      AutoSeeker.median_mileage(@seeker.autos).must_equal 30.0
    end

    it "rejects autos without mileage from median calc" do
      @seeker.filter :color, 'Teal'
      AutoSeeker.median_mileage(@seeker.autos).must_equal 27.0
    end
  end
end
