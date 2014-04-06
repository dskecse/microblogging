require 'spec_helper'

describe Relationship do
  let(:follower) { create(:user) }
  let(:followed) { create(:user) }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  subject { relationship }

  it { should be_valid }

  describe 'follower methods' do
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    its(:follower) { should eq follower }
    its(:followed) { should eq followed }
  end

  context 'when followed_id is not present' do
    before { relationship.followed_id = nil }

    it { should_not be_valid }
  end

  context 'when follower_id is not present' do
    before { relationship.follower_id = nil }

    it { should_not be_valid }
  end
end
