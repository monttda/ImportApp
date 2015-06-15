FactoryGirl.define do
  # By default operations status are accepted if desired the oposite use the
  # trait declined
  factory :operation do
    invoice_num SecureRandom.hex
    invoice_date Date.today
    operation_date Date.today
    amount Random.new.rand(20.0..2000.0)
    reporter "King Ragnar Lodbrok"
    notes "Just rom random note"
    company
    status "accepted"

    transient do
      category_name nil
    end
    after(:build) do |operation, evaluator|
      if evaluator.category_name
        operation.categories << create(:category, name: evaluator.category_name)
      else
        operation.categories << create(:category)
      end
    end

    trait :declined do
      status "declined"
    end



  end

end
