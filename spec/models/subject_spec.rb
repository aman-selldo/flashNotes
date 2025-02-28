require 'rails_helper'

RSpec.describe Subject, type: :model do
  describe "Validations" do
    it "is valid with a name" do
      subject = Subject.new(name: "Math")
      expect(subject).to be_valid
    end

    it "is invalid without a name" do
      subject = Subject.new(name: nil)
      expect(subject).to_not be_valid
    end
  end
end
