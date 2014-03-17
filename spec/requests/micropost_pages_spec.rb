require 'spec_helper'

describe 'MicropostPages' do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { valid_signin user }

  describe 'micropost creation' do
    before { visit root_path }

    context 'with invalid information' do
      it 'does not create a micropost' do
        expect { click_button 'Post' }.not_to change(Micropost, :count)
      end

      describe 'error messages' do
        before { click_button 'Post' }

        it { should have_content('error') }
      end
    end

    context 'with valid information' do
      before { fill_in 'micropost_content', with: 'Death Metal Rooster' }

      it 'creates a micropost' do
        expect { click_button 'Post' }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe 'micropost destruction' do
    before { FactoryGirl.create(:micropost, user: user) }

    content 'as a correct user' do
      before { visit root_path }

      it 'deletes a micropost' do
        expect { click_link 'delete' }.to change(Micropost, :count).by(-1)
      end
    end
  end
end
