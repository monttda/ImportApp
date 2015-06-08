require 'rails_helper'

RSpec.describe Category do
  let(:the_category){
    build(:category)
  }

  context 'must respond_to' do

    it "name" do
      expect(the_category).to respond_to(:name)
    end
    it "operations" do

      expect(the_category).to respond_to(:operations)
    end
  end

  it "should be valid" do
    expect(the_category).to be_valid
  end

  it "should not be valid when empty" do
    blank_category = Category.new()
    blank_category.valid?
    expect(blank_category.errors.size).to eql(1)
  end
end
