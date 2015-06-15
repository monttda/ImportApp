require 'rails_helper'

RSpec.describe  Operation do
  let(:the_operation){
    build(:operation)
  }

  let(:company) do
    create(:company)
  end

  let(:accepted_op) do
    create(:operation,
           category_name: "apple",
           company: company,
           reporter: "bob",
           invoice_num: "111a")

  end

  let(:declined_op) do
    create(:operation,
           :declined,
           category_name: "cake",
           company: company,
           reporter: "mike",
           invoice_num: "222b")
  end

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

  describe "#to_array" do
    it "should return and array with all the info of the operation" do
      the_operation.save
      expect(the_operation.to_array).
        to contain_exactly( the_operation.company.name,
                            the_operation.invoice_num,
                            the_operation.invoice_date,
                            the_operation.operation_date,
                            the_operation.reporter,
                            the_operation.notes,
                            the_operation.status,
                            the_operation.categories.first.name)
    end
  end

  describe ".for_company" do
    context " shouls return the operations of the company filtered" do
      before(:each) do
        accepted_op
        declined_op
      end
      it "by category" do
        result = Operation.for_company('ple', company.id)
        expect(result).to contain_exactly(accepted_op)
      end
      it "by reporter" do
        result = Operation.for_company('o', company.id)
        expect(result).to contain_exactly(accepted_op)
      end
      it "by invoice"  do
        result = Operation.for_company('b', company.id)
        expect(result).to contain_exactly(declined_op,accepted_op)

      end
      it "by status" do
        result = Operation.for_company('dec', company.id)
        expect(result).to contain_exactly(declined_op)

      end
    end

  end
end
