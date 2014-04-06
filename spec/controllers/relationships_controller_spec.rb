require 'spec_helper'

describe RelationshipsController do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before { valid_signin user, no_capybara: true }

  describe 'POST /create' do
    it 'increments the Relationship count' do
      expect do
        xhr :post, :create, relationship: { followed_id: other_user.id }
      end.to change(Relationship, :count).by(1)
    end

    it 'responds with success' do
      xhr :post, :create, relationship: { followed_id: other_user.id }
      expect(response).to be_success
    end
  end

  describe 'DELETE /destroy' do
    before { user.follow!(other_user) }
    let(:relationship) do
      user.relationships.find_by(followed_id: other_user.id)
    end

    it 'decrements the Relationship count' do
      expect do
        xhr :delete, :destroy, id: relationship.id
      end.to change(Relationship, :count).by(-1)
    end

    it 'responds with success' do
      xhr :delete, :destroy, id: relationship.id
      expect(response).to be_success
    end
  end
end
