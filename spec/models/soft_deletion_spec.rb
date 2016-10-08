require "spec_helper"

describe SoftDeletion do
  class Fun < ActiveRecord::Base
    include SoftDeletion
  end

  around :each do |example|
    connection = ActiveRecord::Base.connection
    connection.create_table :funs do |t|
      t.boolean :deleted, default: "f"
    end
    example.run
    connection.drop_table :funs
  end

  it "soft-deletes objects" do
    fun = Fun.create!
    fun.destroy

    expect(Fun.unscoped.where(id: fun.id)).to be_present
  end

  it "defaults the scope" do
    fun1 = Fun.create!
    fun2 = Fun.create!

    fun2.destroy

    expect(Fun.count).to eq(1)
    expect(Fun.unscoped.count).to eq(2)
  end
end
