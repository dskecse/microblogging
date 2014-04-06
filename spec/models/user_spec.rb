require 'spec_helper'

describe User do
  before do
    @user = User.new(name: 'Example User',
                     email: 'user@example.com',
                     password: 'foobar',
                     password_confirmation: 'foobar')
  end
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }

  it { should be_valid }
  it { should_not be_admin }

  context 'with admin attribute set to "true"' do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  context 'when name is not present' do
    before { @user.name = '' }
    it { should have(1).error_on(:name) }
  end

  context 'when email is not present' do
    before { @user.email = '' }
    it { should_not be_valid }
  end

  context 'when name is too long' do
    before { @user.name = 'a' * 51 }
    it { should_not be_valid }
  end

  context 'when email format is invalid' do
    %w(user@foo,com user_at_foo.org example.user@foo.
       foo@bar_baz.com foo@bar+baz.com foo@bar..com).each do |invalid_address|
      it 'is not valid' do
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  context 'when email format is valid' do
    %w(user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn).each do |address|
      it 'is valid' do
        @user.email = address
        expect(@user).to be_valid
      end
    end
  end

  context 'when email is already taken' do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  context 'email address with mixed case' do
    let(:mixed_case_email) { 'Foo@ExAMPle.CoM' }

    it 'is saved as all lower-case' do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  context 'when password is not present' do
    before { @user.password = @user.password_confirmation = ' ' }
    it { should_not be_valid }
  end

  context 'when password does not match confirmation' do
    before { @user.password_confirmation = 'mismatch' }
    it { should_not be_valid }
  end

  context 'when password is short' do
    before { @user.password = @user.password_confirmation = 'a' * 5 }
    it { should_not be_valid }
  end

  context 'return value of authenticate method' do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    context 'with valid password' do
      it { should eq found_user.authenticate(@user.password) }
    end

    context 'with invalid password' do
      let(:user_for_invalid_password) { found_user.authenticate('invalid') }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe 'remember token' do
    before { @user.save }

    its(:remember_token) { should_not be_blank }
  end

  describe 'micropost associations' do
    before { @user.save }
    let!(:older_micropost) do
      create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it 'has microposts in the right order' do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    it 'destroys associated microposts' do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect do
          Micropost.find(micropost.id)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe 'status' do
      let(:unfollowed_post) do
        create(:micropost, user: create(:user))
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
    end
  end

  describe 'following' do
    let(:other_user) { create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe 'followed user' do
      subject { other_user }

      its(:followers) { should include(@user) }
    end

    describe 'and unfollowing' do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end
end
