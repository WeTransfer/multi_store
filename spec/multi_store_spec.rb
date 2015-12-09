require 'spec_helper'

module ActiveSupport
  module Cache
    describe MultiStore do
      it 'has a version number' do
        expect(::MultiStore::VERSION).not_to be nil
      end
    end
  end
end
