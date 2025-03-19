require 'rails_helper'

RSpec.describe "User Authentication", type: :request do
  describe "POST /signup" do
    let(:valid_attributes) { { user: { username: "John Doe", email: "john@example.com", password: "password123" } } }
    let(:invalid_attributes) { { user: { username: "", email: "invalid", password: "" } } }

    it "registers a new user with valid details" do
      expect {
        post "/signup", params: valid_attributes
      }.to change(User, :count).by(1)

      expect(response).to redirect_to subjects_path
    end

    it "fails to register a user with invalid details" do
      expect {
        post "/signup", params: invalid_attributes
      }.not_to change(User, :count)

      expect(response).to redirect_to signup_path
    end
  end

  describe "POST /login" do
    let(:user) { create(:user, email: "john@example.com", password: "password123") }

    it "fails to log in with invalid credentials" do
      post "/login", params: { email: user.email, password: "wrongpassword" }
      expect(response).to have_http_status(:bad_request)
    end
  end
end
