require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    it "is valid with a username, email, and password" do
      user = User.new(username: "John Doe", email: "john@example.com", password: "password123")
      expect(user).to be_valid
    end

    it "is invalid without a username" do
      user = User.new(username: nil, email: "john@example.com", password: "password123")
      expect(user).to_not be_valid
    end

    it "is invalid without an email" do
      user = User.new(username: "John Doe", email: nil, password: "password123")
      expect(user).to_not be_valid
    end

    it "is invalid without a password" do
      user = User.new(username: "John Doe", email: "john@example.com", password: nil)
      expect(user).to_not be_valid
    end

    it "is invalid with a duplicate email" do
      create(:user, email: "john@example.com")  # Creating a user with the same email
      user = User.new(username: "John Doe", email: "john@example.com", password: "password123")
      expect(user).to_not be_valid
    end
  end
end
