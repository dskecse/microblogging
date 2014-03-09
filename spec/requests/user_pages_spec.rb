require 'spec_helper'

describe 'UserPages' do
  subject { page }

  describe 'index' do
    before do
      valid_signin FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: 'Bob', email: 'bob@example.com')
      FactoryGirl.create(:user, name: 'Ben', email: 'ben@example.com')
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }
    it 'lists each user' do
      User.all.each do |user|
        expect(page).to have_selector('li', text: user.name)
      end
    end
  end

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

  describe 'edit' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      valid_signin user
      visit edit_user_path(user)
    end

    context 'page' do
      it { should have_content('Update your profile') }
      it { should have_title('Edit user') }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    context 'with invalid information' do
      before { click_button 'Save changes' }

      it { should have_content('error') }
    end

    context 'with valid information' do
      let(:new_name)  { 'New Name' }
      let(:new_email) { 'new@example.com' }
      before do
        fill_in 'Name',         with: new_name
        fill_in 'Email',        with: new_email
        fill_in 'Password',     with: user.password
        fill_in 'Confirmation', with: user.password
        click_button 'Save changes'
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end
end
