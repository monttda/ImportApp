require 'rails_helper'

RSpec.describe  Operation do
  let(:the_operation){
    build(:operation)
  }

  context 'must respond_to' do

    it "operation_date" do
      expect(the_operation).to respond_to(:operation_date)
    end
    it "invoice_num" do
      expect(the_operation).to respond_to(:invoice_num)
    end
    it "invoice_date" do
      expect(the_operation).to respond_to(:invoice_date)
    end
    it "amount" do
      expect(the_operation).to respond_to(:amount)
    end
    it "reporter" do
      expect(the_operation).to respond_to(:reporter)
    end
    it "notes" do
      expect(the_operation).to respond_to(:notes)
    end
    it "kind" do
      expect(the_operation).to respond_to(:kind)
    end
    it "status" do
      expect(the_operation).to respond_to(:status)
    end
    it "company" do
      expect(the_operation).to respond_to(:company)
    end
    it "categories" do
      expect(the_operation).to respond_to(:categories)
    end
  end

  it "should be valid" do
    expect(the_operation).to be_valid
  end

  it "should not be valid when empty" do
    blank_operation = Operation.new()
    blank_operation.valid?
    expect(blank_operation.errors.size).to eql(7)
  end
end
