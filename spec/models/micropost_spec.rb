require 'spec_helper'

describe Micropost do
  let(:user) { create(:user) }
  before { @micropost = user.microposts.build(content: 'Lorem ipsum') }

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq(user) }

  it { should be_valid }

  it { should validate_presence_of :user }

  describe 'with blank content' do
    before { @micropost.content = ' ' }

    it { should_not be_valid }
  end

  describe 'with content is too long' do
    before { @micropost.content = 'a' * 141 }

    it { should_not be_valid }
  end
end
