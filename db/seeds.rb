# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#管理者アカウントです
Admin.create!(email: "rai93@test.com",
              password: "rails9193")

#テストユーザーです
customers = Customer.create!(
  [
    {email: 'taro@test.com', name: 'taro', password: 'password', profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-customer1.png"), filename:"sample-customer1.png")},
    {email: 'james@test.com', name: 'James', password: 'password', profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-customer2.png"), filename:"sample-customer2.png")},
    {email: 'lucas@test.com', name: 'Lucas', password: 'password', profile_image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-customer3.png"), filename:"sample-customer3.png")},
    {email: 'hanako@test.com', name: 'hanako', password: 'password', customer_style: 'quited'},
    {email: 'jiro@test.com', name: 'jiro', password: 'password', customer_style: 'block'}
  ]
)

c_taro = Customer.find_by(email: "taro@test.com")
c_james = Customer.find_by(email: "james@test.com")
c_lucas = Customer.find_by(email: "lucas@test.com")

e_taro = c_taro.exercises.create!(body: "こんにちは")
c_taro.exercises.find(e_taro.id).favorites.create!(customer_id: c_james.id)
e_taro.create_notification_favorite!(c_james)
c_taro.exercises.find(e_taro.id).favorites.create!(customer_id: c_lucas.id)
e_taro.create_notification_favorite!(c_lucas)
c_taro.follow!(c_james)
c_james.create_notification_follow!(c_taro)
c_taro.follow!(c_lucas)
c_james.create_notification_follow!(c_lucas)
taro_comment = e_taro.comments.create!(customer_id: c_james.id, comment_to: "いいね!")
e_taro.create_notification_comment!(c_james, taro_comment)

e_james = c_james.exercises.create!(body: "hello", body_images: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-exercise1.jpg"), filename:"sample-exercise1.jpg"))
c_james.exercises.find(e_james.id).favorites.create!(customer_id: c_lucas.id)
e_james.create_notification_favorite!(c_lucas)
c_james.follow!(c_lucas)
c_lucas.create_notification_follow!(c_james)
james_comment = e_james.comments.create!(customer_id: c_lucas.id, comment_to: "hello!")
e_james.create_notification_comment!(c_lucas, james_comment)

e_lucas = c_lucas.exercises.create!(body: "頑張ります!", body_images: [
  ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-exercise2.jpg"), filename:"sample-exercise2.jpg" ),
  ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-exercise3.jpg"), filename:"sample-exercise3.jpg" )
]
)
c_lucas.exercises.find(e_lucas.id).favorites.create!(customer_id: c_taro.id)
e_lucas.create_notification_favorite!(c_taro)
c_lucas.follow!(c_james)
c_james.create_notification_follow!(c_lucas)




