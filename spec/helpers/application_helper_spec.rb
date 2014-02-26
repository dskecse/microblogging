require 'spec_helper'

describe ApplicationHelper do
  describe 'full_title' do
    context 'with page title provided' do
      it 'includes the page title' do
        expect(full_title('foo')).to match(/foo/)
      end

      it 'includes the base title' do
        expect(full_title('foo')).to match(/\ARuby on Rails Tutorial Sample App/)
      end
    end

    context 'without page title provided' do
      it 'not includes the bar for the home page' do
        expect(full_title('')).not_to match(/\|/)
      end
    end
  end
end
