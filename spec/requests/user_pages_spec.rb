require 'spec_helper'

describe 'UserPages' do
  subject { page }

  describe 'profile page' do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe 'signup page' do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe 'signup' do
    before { visit signup_path }
    let(:submit) { 'Create account' }

    context 'with invalid information' do
      it 'does not create a user' do
        expect { click_button submit }.not_to change(User, :count)
      end

      context 'after submission' do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end
    end

    context 'with valid information' do
      before { fill_form_using('user@example.com') }

      it 'creates a user' do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      context 'after saving the user' do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_sunny_message('Welcome') }
      end
    end
  end
end
