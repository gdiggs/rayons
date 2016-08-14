require "spec_helper"

describe StatsController, type: :controller do
  describe "#index" do
    it "should set title" do
      get :index
      assert_select "title", "Rayons\n\u2669 Stats"
    end
  end

  describe "#time_machine" do
    it "should assign a time machine" do
      get :time_machine
      time_machine = assigns(:time_machine)
      expect(time_machine).not_to be_nil
      expect(time_machine.base_date).to eq(Time.now.to_date)
    end

    it "should accept date parameters" do
      get :time_machine, params: { month: 1, day: 31 }
      time_machine = assigns(:time_machine)
      expect(time_machine).not_to be_nil
      expect(time_machine.base_date).to eq(Time.local(Time.now.year, 1, 31).to_date)
    end
  end
end
