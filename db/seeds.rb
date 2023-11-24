# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
if Rails.env.development?
  10.times do |i|
    User.where(email: "user#{i}@localhost.email").first_or_create!(email: "user#{i}@localhost.email", password: "Aa@123456") do |user|
      user.wallets.build(enabled: true) unless user.active_wallet.present?
      user.save!
    end
  end
end
