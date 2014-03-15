require 'spec_helper'

describe UsersController do
  describe 'GET new' do
    context 'when signed in' do
      before do
        valid_signin FactoryGirl.create(:user), no_capybara: true
      end

      it 'redirects to root_url' do
        get :new
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'POST create' do
    context 'when signed in' do
      before do
        valid_signin FactoryGirl.create(:user), no_capybara: true
      end

      it 'redirects to root_url' do
        post :create, {}
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
