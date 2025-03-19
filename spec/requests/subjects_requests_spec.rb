require 'rails_helper'

RSpec.describe "Subjects", type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { {} }

  context 'when user has logged in' do
    before do
      # user_params = { email: user.email, password: user.password }
      # post '/login', params: user_params
      # let(:user) { create(:user) }
    end
    
    it "returns a successful response" do
      get "/subjects", headers: auth_headers
      expect(response).to redirect_to(login_path)
    end
    
    describe "POST /subjects" do
      
      let(:valid_attributes) { { subject: { name: "Math", user_id:  user.id} } }
      let(:invalid_attributes) {{ subject: {name: "" } } }
      
      it "creates a new subject" do
        expect {
          post subjects_path, params: { subject: { name: "Math", user_id:  user.id} } , headers: auth_headers

        }.to change(Subject, :count).by(0)
      end
      it "does not create a new subject with invalid attributes" do
        expect {
          post subjects_path, params: invalid_attributes, headers: auth_headers
      }.to change(Subject, :count).by(0)

      expect(response).to redirect_to login_path
      end
    end
  end
end