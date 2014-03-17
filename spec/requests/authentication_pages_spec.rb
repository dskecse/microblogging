require 'spec_helper'

describe 'Authentication' do
  subject { page }

  describe 'signin page' do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end

  describe 'signin' do
    before { visit signin_path }

    context 'with invalid information' do
      before { click_button 'Sign in' }

      it { should have_title('Sign in') }
      it { should have_error_message('Invalid') }

      context 'after visiting another page' do
        before { click_link 'Home' }

        it { should_not have_error_message('Invalid') }
      end
    end

    context 'with valid information' do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }

      it { should have_title(user.name) }
      it { should have_link('Users',    href: users_path) }
      it { should have_link('Profile',  href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      context 'followed by signout' do
        before { click_link 'Sign out' }

        it { should have_link('Sign in') }
      end
    end
  end

  describe 'authorization' do
    context 'for non-signed-in users' do
      let(:user) { FactoryGirl.create(:user) }

      context 'when attempting to visit a protected page' do
        before do
          visit edit_user_path(user)
          fill_in 'Email',    with: user.email
          fill_in 'Password', with: user.password
          click_button 'Sign in'
        end

        describe 'after signing in' do
          it 'renders the desired protected page' do
            expect(page).to have_title('Edit user')
          end
        end
      end

      context 'in the Microposts controller' do
        describe 'submitting to the create action' do
          before { post microposts_path }

          specify { expect(response).to redirect_to(signin_path) }
        end

        describe 'submitting to the destroy action' do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }

          specify { expect(response).to redirect_to(signin_path) }
        end
      end

      describe 'visiting the user index' do
        before { visit users_path }

        it { should have_title('Sign in') }
      end

      context 'visiting the user edit page' do
        before { visit edit_user_path(user) }

        it { should have_title('Sign in') }
      end

      context 'submitting to the user update action' do
        before { patch user_path(user) }

        specify { expect(response).to redirect_to(signin_path) }
      end
    end

    context 'for wrong users' do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: 'wrong@example.org') }
      before { valid_signin user, no_capybara: true }

      describe 'submitting a GET request to the edit action' do
        before { get edit_user_path(wrong_user) }

        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe 'submitting a PATCH request to the update action' do
        before { patch user_path(wrong_user) }

        specify { expect(response).to redirect_to(root_url) }
      end
    end
  end
end
