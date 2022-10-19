FactoryBot.define do
  factory :expense do
    user_id { User.pluck(:id).sample }
    category_id { Category.pluck(:id).sample }
    amount { 99 }
    description { 'MyString' }
  end
end
