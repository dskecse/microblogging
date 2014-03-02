require 'spec_helper'

describe User do
  before do
    @user = User.new(name: 'Example User', email: 'user@example.com')
  end
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }

  it { should be_valid }

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
end
