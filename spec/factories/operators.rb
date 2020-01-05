FactoryBot.define do
  factory :operator, class: Models::Operator do
    email { FFaker::Internet.email }
    password { SecureRandom.hex(8) }
    password_confirmation { password }
  end
end
