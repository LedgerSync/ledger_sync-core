# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LedgerSync::Type::StringFromSet do
  let(:type) do
    described_class.new(
      values: %w[
        foo
        bar
        baz
      ]
    )
  end

  describe '#assert_valid' do
    it { expect(type.assert_valid(value: nil)).to be_nil }
    it { expect(type.assert_valid(value: 'foo')).to be_nil }
    it do
      expect { type.assert_valid(value: 'asdf') }.to raise_error(
        LedgerSync::Error::TypeError::StringFromSetError
      )
    end
  end

  describe '#type' do
    it { expect(type.type).to eq(:StringFromSet) }
  end

  describe '#valid?' do
    it { expect(type.send(:valid?, value: nil)).to be_truthy }
    it { expect(type.send(:valid?, value: 'asdf')).to be_falsey }
  end

  describe '#values' do
    it { expect(described_class.new(values: %i[test])).to respond_to(:values) }
  end
end
