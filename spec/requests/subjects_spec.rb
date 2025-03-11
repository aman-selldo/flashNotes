require 'rails_helper'

RSpec.describe "Subjects API", type: :request do
  let(:user) {create(:user) }
  let(:auth_headers) {{ "Authorization" => "Bearer #{user.generate_jwt}"}}

  describe "GET /subjects" do
    it "returns all subjects" do
      create(:subject, user:user)
      get "/subjects", headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(request.body).size).to_eq(1)
    end
  end



  describe "POST /subjects" do
    it "creates a new subject" do
      post "/subjects", params: {subject: [name: "Science"]}, headers: auth_headers
      expect(response).to have_http_status(:created)
      expect(subject.last.name).to eq("Science")
    end
  end

  describe "DELETE /subjects/:id" do
    it "deletes a subject " do
      subject = create(:subject, user:user)
      delete "/subjects/#{subject.id}", headers: auth_headers

      expect(response).to have_http_status(:no_content)
      expect(Subject.exists?(subject.id)).to be_falsey
    end
  end
end


