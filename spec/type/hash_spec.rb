# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LedgerSync::Type::Hash do
  let(:type) { described_class.new }

  describe '#cast?' do
    it { expect(type.cast?).to be_truthy }
  end

  describe '#cast_value' do
    it { expect(type.send(:cast_value, value: { a: :b })).to eq({ a: :b }) }
    it { expect(type.send(:cast_value, value: :asdf)).to eq({ value: :asdf }) }
  end

  describe '#changed_in_place?' do
    it { expect(type.changed_in_place?({ a: :b }, { a: :b })).to be_falsey }
    it { expect(type.changed_in_place?({ a: :b }, { a: :c })).to be_truthy }
  end

  describe '#type' do
    it { expect(type.type).to eq(:id) }
  end

  describe '#valid_classes' do
    it { expect(type.valid_classes).to eq([Hash]) }
  end
end
