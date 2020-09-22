# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LedgerSync::Serialization::Type::SerializerReferencesManyType do
  let(:serializer) { LedgerSync::Ledgers::TestLedger::Subsidiary::Serializer }
  let(:type) { described_class.new(serializer: serializer) }
  let(:value) do
    [
      test_ledger_module::Subsidiary.new(name: 'foo'),
      test_ledger_module::Subsidiary.new(name: 'bar')
    ]
  end

  describe '#cast_value' do
    subject do
      type.cast_value(value: value)
    end

    it { expect(subject).to be_a(Array) }
    it { expect(subject).to eq([{ 'name' => 'foo', 'state' => nil }, { 'name' => 'bar', 'state' => nil }]) }
  end
end
