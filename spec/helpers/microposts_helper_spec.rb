require 'spec_helper'

describe MicropostsHelper do
  describe 'wrap' do
    it 'adds zero width spaces to long texts' do
      expect(wrap('a' * 35)).to eq("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\u200baaaaa")
    end
  end
end
