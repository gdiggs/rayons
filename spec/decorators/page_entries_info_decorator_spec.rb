require "spec_helper"

describe PageEntriesInfoDecorator do
  describe "total_count" do
    it "should delimit things > 999" do
      collection = stub("collection", total_count: 1_234_567)
      assert_equal "1,234,567", PageEntriesInfoDecorator.new(collection).total_count
    end
  end
end
