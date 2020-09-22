# frozen_string_literal: true

require 'spec_helper'

support :test_ledger_helpers

RSpec.describe LedgerSync::Ledgers::Client, type: :serializable do
  include TestLedgerHelpers

  it do
    h = { root: 'LedgerSync::Ledgers::TestLedger::Client/d3fecf5221e8cae01e4f66e3899f555f',
          objects: { 'LedgerSync::Ledgers::TestLedger::Client/d3fecf5221e8cae01e4f66e3899f555f' =>
        { id: 'LedgerSync::Ledgers::TestLedger::Client/d3fecf5221e8cae01e4f66e3899f555f',
          object: 'LedgerSync::Ledgers::TestLedger::Client',
          fingeprint: 'd3fecf5221e8cae01e4f66e3899f555f',
          data: { ledger_configuration: { object: :reference,
                                          id: 'LedgerSync::LedgerConfiguration/8a1887e6c3179f671b8e65d05c131971' } } },
                     'LedgerSync::LedgerConfiguration/8a1887e6c3179f671b8e65d05c131971' =>
        { id: 'LedgerSync::LedgerConfiguration/8a1887e6c3179f671b8e65d05c131971',
          object: 'LedgerSync::LedgerConfiguration',
          fingeprint: '8a1887e6c3179f671b8e65d05c131971',
          data: { module_string: 'TestLedger',
                  root_key: :test_ledger,
                  base_module: 'LedgerSync::Ledgers::TestLedger',
                  client_path: '/Users/ryanwjackson/dev/ledger_sync/ledger_sync-core/spec/test_ledger/client',
                  client_class: 'LedgerSync::Ledgers::TestLedger::Client',
                  name: 'Test Ledger',
                  root_path: '/Users/ryanwjackson/dev/ledger_sync/ledger_sync-core/spec/test_ledger',
                  aliases: [:test] } } } }
    expect(test_ledger_client.simply_serialize).to eq(h)
  end

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
