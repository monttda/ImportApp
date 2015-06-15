require 'rails_helper'

RSpec.describe Company, type: :model do
  let(:the_company){
    build(:company)
  }

  let(:the_operation){
    create(:operation, company: the_company,
           invoice_num: "1", amount: 3000.0)
  }
  context 'must respond_to' do

    it "name" do
      expect(the_company).to respond_to(:name)
    end
    it "operations" do

      expect(the_company).to respond_to(:operations)
    end
  end

  it "should be valid" do
    expect(the_company).to be_valid
  end

  it "should not be valid when empty" do
    blank_company = Company.new()
    blank_company.valid?
    expect(blank_company.errors.size).to eql(1)
  end

  describe ".display_information" do

    it 'should return a hash containing the requiered information'\
       'of the company' do
         # Call the operation variable to it actually get's saved into the
         # database
         the_operation
         result = Company.display_information
         expected_text = "#{the_company.name} | Number of operations "\
                         "1 | Average amount of "\
                         "operations: #{the_operation.amount} | "\
                         "Highest operation: #{the_operation.amount} | "\
                         "Accepted operations: 1"
         expect(result.first).to include(text: expected_text,
                                         id: the_company.id)

       end
  end
end
