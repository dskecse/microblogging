require 'spec_helper'

describe 'Static pages' do
  subject { page }

  describe 'Home page' do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like 'all static pages'
    it { should_not have_title('| Home') }

    context 'for signed-in users' do
      let(:user) { create(:user) }
      before do
        create(:micropost, user: user, content: 'Lorem ipsum')
        create(:micropost, user: user, content: 'Dolor sit amet')
        valid_signin user
        visit root_path
      end

      it 'renders the user feed' do
        user.feed.each do |item|
          expect(page).to have_selector("li##{ item.id }", text: item.content)
        end
      end

      describe 'follower/following counts' do
        let(:other_user) { create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link('0 following', href: following_user_path(user)) }
        it { should have_link('1 followers', href: followers_user_path(user)) }
      end
    end
  end

  describe 'Help page' do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like 'all static pages'
  end

  describe 'About page' do
    before { visit about_path }
    let(:heading)    { 'About Us' }
    let(:page_title) { 'About' }

    it_should_behave_like 'all static pages'
  end

  describe 'Contact page' do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like 'all static pages'
  end
end
