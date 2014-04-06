require 'spec_helper'

describe StatsController do
  describe '#index' do
    it 'should set title' do
      get :index
      assert_select 'title', "Rayons\n\u2669 Stats"
    end
  end

end

