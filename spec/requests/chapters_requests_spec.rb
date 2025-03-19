require 'rails_helper'

RSpec.describe "Chapters", type: :request do
  let(:user) { create(:user, email: "prajwal@gmail.com", password:"prajwal@1234") }
  let(:subject_record) { create(:subject, user: user) }

  before do
    user_params = { user: {email: user.email, password: user.password} }
    post '/login', params: user_params     
    @auth_token = response.cookies['jwt']
    # puts "Auth Token: #{@auth_token}"
  end

  describe "POST /subjects/:subject_id/chapters" do
    let(:valid_attributes) { { chapter: { name: "resonance" } } }

    it "creates a new chapter" do
      expect {
        post "/subjects/#{subject_record.id}/chapters", params: valid_attributes, headers: {'Cookie' => "jwt=#{@auth_token}"} 
      }.to change(Chapter, :count).by(1)

      expect(response).to redirect_to subject_chapters_path
    end
  end

  describe "PUT /chapters/:id" do
        
    let!(:chapter) { create(:chapter, subject: subject_record) }
    let(:updated_attributes) { { chapter: { name: "resonanceeee" } } }

    it "updates an existing chapter" do
      put "/subjects/#{subject_record.id}/chapters/#{chapter.id}/", params: updated_attributes, headers: {"Cookie" => "jwt=#{@auth_token}"}      
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE chapter" do
    let!(:chapter) { create(:chapter, subject: subject_record) }

    it "deletes a chapter" do
      expect {
        delete "/subjects/#{subject_record.id}/chapters/#{chapter.id}/", headers: {'Cookie' => "jwt=#{@auth_token}"}
      }.to change(Chapter, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
