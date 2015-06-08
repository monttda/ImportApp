FactoryGirl.define do
  TYPES = ["consulting services","delegation", "important", "personal"]
  factory :category do
    sequence(:name) {|n| TYPES[n % TYPES.size]}
  end

end
