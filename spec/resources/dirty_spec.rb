# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LedgerSync::Resource do
  let(:name) { 'Test Name' }
  let(:resource) { LedgerSync::Ledgers::TestLedger::Customer.new }

  it do
    expect(LedgerSync::Ledgers::TestLedger::Customer.new(name: name)).to be_changed
    customer = LedgerSync::Ledgers::TestLedger::Customer.new
    expect(customer).not_to be_changed
  end

  context 'when references_many' do
    it '<<' do
      e = LedgerSync::Ledgers::TestLedger::Customer.new
      eli = LedgerSync::Ledgers::TestLedger::Subsidiary.new
      expect(e.changes).to be_empty
      expect(e.subsidiaries).not_to be_changed
      expect(e.subsidiaries.changes).to eq({})
      e.subsidiaries << eli
      expect(e.subsidiaries).to be_changed
      expect(e.subsidiaries.changes).to eq('value' => [[], [eli]])
      expect(e).to be_changed
      expect(e.changes).to have_key('subsidiaries')
      e.save
      expect(e.subsidiaries).not_to be_changed
      expect(e).not_to be_changed
    end
  end

  context 'when references_one' do
    it '<<' do
      e = LedgerSync::Ledgers::TestLedger::Customer.new
      subsidiary = LedgerSync::Ledgers::TestLedger::Subsidiary.new
      expect(e.changes).to be_empty
      e.subsidiary = subsidiary
      expect(e.changes).to have_key('subsidiary')
    end
  end

  it do
    expect(resource).not_to be_changed
    expect(resource.external_id).to be_nil
    resource.external_id = :asdf
    expect(resource.external_id).to eq('asdf')
    expect(resource).to be_changed
    expect(resource.changes).to eq('external_id' => [nil, 'asdf'])
    resource.save
    expect(resource).not_to be_changed
    expect(resource.external_id).to eq('asdf')
    expect(resource.changes).to eq({})
  end

  it do
    expect(resource).not_to be_changed
    expect(resource.ledger_id).to be_nil
    resource.ledger_id = :asdf
    expect(resource.ledger_id).to eq('asdf')
    expect(resource).to be_changed
    expect(resource.changes).to eq('ledger_id' => [nil, 'asdf'])
    resource.save
    expect(resource).not_to be_changed
    expect(resource.ledger_id).to eq('asdf')
    expect(resource.changes).to eq({})
  end

  it do
    expect(resource).not_to be_changed
    expect(resource.name).to be_nil
    resource.name = 'asdf'
    expect(resource.name).to eq('asdf')
    expect(resource).to be_changed
    expect(resource.changes).to eq('name' => [nil, 'asdf'])
    resource.save
    expect(resource).not_to be_changed
    expect(resource.name).to eq('asdf')
    expect(resource.changes).to eq({})
  end
end
