# frozen_string_literal: true

require 'spec_helper'

support :test_ledger_helpers

RSpec.describe LedgerSync::Ledgers::Client, type: :serializable do
  include TestLedgerHelpers

  it do
    client1 = LedgerSync.ledgers.test_ledger.new(
      api_key: 'api_key'
    )

    client2 = LedgerSync.ledgers.test_ledger.new(
      api_key: 'api_key'
    )

    client3 = LedgerSync.ledgers.test_ledger.new(
      api_key: 'DOES NOT MATCH'
    )

    expect(client1.simply_serialize).to eq(client2.simply_serialize)
    expect(client1.simply_serialize).not_to eq(client3.simply_serialize)

    expect(client1.fingerprint).to eq(client2.fingerprint)
    expect(client1.fingerprint).not_to eq(client3.fingerprint)
  end
end
