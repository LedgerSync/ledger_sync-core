# frozen_string_literal: true

require 'spec_helper'

support :test_ledger_helpers

RSpec.describe LedgerSync::Ledgers::Searcher do
  include TestLedgerHelpers

  let(:client) { test_ledger_client }
  let(:query) { 'qqq' }

  subject { described_class.new(client: client, query: query) }

  describe '#next_searcher' do
    it { expect { subject.next_searcher }.to raise_error(NotImplementedError) }
  end

  describe '#previous_searcher' do
    it { expect { subject.previous_searcher }.to raise_error(NotImplementedError) }
  end

  describe '#resources' do
    it { expect { subject.resources }.to raise_error(NotImplementedError) }
  end

  describe '#search' do
    it { expect { subject.search }.to raise_error(NotImplementedError) }
  end
end
