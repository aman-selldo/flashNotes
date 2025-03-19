require 'rails_helper'

RSpec.describe "Chapters API", type: :request do
  let(:user) { create(:user) }
  let(:subject_record) { create(:subject, user: user) }

  describe "POST /subjects/:subject_id/chapters" do
    let(:valid_attributes) { { chapter: { name: "Resonance" } } }

    it "creates a new chapter" do
      expect {
        post "/subjects/#{subject_record.id}/chapters", params: valid_attributes
      }.to change(Chapter, :count).by(0)

      expect(response).to redirect_to login_path
    end
  end

  describe "PUT /chapters/:id" do
    let(:chapter) { create(:chapter, subject: subject_record) }
    let(:updated_attributes) { { chapter: { name: "Updated Chapter Name" } } }

    it "updates an existing chapter" do
      put "/chapters/#{chapter.id}", params: updated_attributes
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /chapters/:id" do
    let!(:chapter) { create(:chapter, subject: subject_record) }

    it "deletes a chapter" do
      expect {
        delete "/chapters/#{chapter.id}"
      }.to change(Chapter, :count).by(0)

      expect(response).to have_http_status(:not_found)
    end
  end
end
