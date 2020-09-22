# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LedgerSync::Serialization::Type::DeserializerType do
  let(:deserializer) { LedgerSync::Ledgers::TestLedger::Subsidiary::Deserializer }
  let(:type) { described_class.new(deserializer: deserializer) }
  let(:value) do
    {
      name: 'foo'
    }
  end
  let(:deserializer_attribute) { test_ledger_module::Customer::Deserializer.attributes['subsidiary'] }

  describe '#cast_value' do
    subject do
      type.cast_value(
        deserializer_attribute: deserializer_attribute,
        resource: test_ledger_module::Customer.new,
        value: value
      )
    end

    it { expect(subject).to be_a(test_ledger_module::Subsidiary) }
    it { expect(subject.name).to eq('foo') }
  end

  describe '#deserializer' do
    it { expect(described_class.new(deserializer: :test)).to respond_to(:deserializer) }
  end
end
