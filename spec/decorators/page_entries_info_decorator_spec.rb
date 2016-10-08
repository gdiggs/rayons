require "spec_helper"

describe PageEntriesInfoDecorator do
  describe "total_count" do
    it "should delimit things > 999" do
      collection = double("collection", total_count: 1_234_567)
      expect(PageEntriesInfoDecorator.new(collection).total_count).to eq "1,234,567"
    end
  end
end
