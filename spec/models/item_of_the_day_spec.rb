require "spec_helper"

describe ItemOfTheDay, type: :model do
  describe "#item" do
    before { Timecop.freeze(Time.local(2016, 9, 9)) }
    after { Timecop.return }

    it "should return the same item within a day" do
      items = [
        ItemOfTheDay.new.item,
        ItemOfTheDay.new.item,
      ]

      pp items

      expect(items.uniq.count).to eq(1)
    end
  end

  describe "#as_json" do
    it "should return the right format" do
      iotd = ItemOfTheDay.new
      result = iotd.as_json
      item = iotd.item

      expect(result[:updateDate].to_date).to eq(Date.today)
      expect(result[:mainText]).to include(item.title, item.artist)
    end
  end
end
