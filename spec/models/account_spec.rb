require 'rails_helper'

RSpec.describe Account, type: :model do
  describe "factory" do
    let(:account) { build(:account) }

    it { expect(account).to be_valid }
  end

  describe "associations" do
    it { is_expected.to have_many(:active_sessions).dependent(:destroy) }
  end

  describe "validations" do
    context "with email" do
      context "when valid" do
        let(:account) { build(:account, email: "aValidEmail@lvh.me") }

        it "not contains email errors" do
          account.valid?
          expect(account.errors[:email]).to be_blank
        end
      end

      context "when invalid" do
        let(:account) { build(:account, email: "unvalidEmail") }

        it "contains email errors" do
          account.valid?
          expect(account.errors[:email]).to eq(["is invalid"])
        end
      end

      context "when not unique" do
        before { create(:account, email: "aValidEmail@lvh.me") }
        let(:account) { build(:account, email: "aValidEmail@lvh.me") }

        it "contains email errors" do
          account.valid?
          expect(account.errors[:email]).to eq(["has already been taken"])
        end
      end
    end

    context "with type" do
      let(:account) { build(:account, email: "unvalidEmail") }

      context "when present" do
      end

      context "when not present" do
      end
    end
  end
end
