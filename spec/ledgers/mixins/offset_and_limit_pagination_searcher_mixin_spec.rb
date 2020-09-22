# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LedgerSync::Ledgers::Mixins::OffsetAndLimitPaginationSearcherMixin do
  let(:klass) do
    test_class = Class.new do
      attr_accessor :limit, :offset, :default_limit

      def paginate(args = {})
        args
      end
    end

    test_class.include described_class

    test = test_class.new
    test.limit = 100
    test.offset = 0
    test.default_limit = 25

    test
  end

  describe '#next_searcher' do
    it { expect(klass.next_searcher).to eq({ limit: 100, offset: 100 }) }
  end
end
