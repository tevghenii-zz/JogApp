# This will guess the User class
FactoryGirl.define do

  factory :user, class: User do
    name 'Evghenii Todorov'
    email 'evghenii@mobex.md'
    role 'user'
    password '123456789'
    password_confirmation '123456789'
  end
  
  factory :manager, class: User do
    name 'Manager'
    email 'manager@mobex.md'
    role 'manager'
    password '123456789'
    password_confirmation '123456789'
  end

  factory :admin, class: User do
    name 'Admin'
    email 'admin@mobex.md'
    role 'admin'
    password '123456789'
    password_confirmation '123456789'
  end
    
  factory :jog do
    date 1.days.ago 
    time 65
    distance 2500
    association :user, factory: :user
  end
    
end

