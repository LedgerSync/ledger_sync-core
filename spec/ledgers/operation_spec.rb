# frozen_string_literal: true

require 'spec_helper'

support :test_ledger_helpers

RSpec.describe LedgerSync::Ledgers::Operation do
  include TestLedgerHelpers

  let(:client) { test_ledger_client }
  let(:resource) { FactoryBot.create(:test_ledger_customer, ledger_id: 1137) }
  let(:operation_class) { client.base_module::Customer::Operations::Create }
  let(:serializer_class) do
    Class.new(LedgerSync::Ledgers::Serializer) do
      attribute :foo,
                resource_attribute: :foo
    end
  end
  let(:validation_contract) do
    Class.new(LedgerSync::Ledgers::Contract) do
      params do
        required(:foo).filled(:string)
      end
    end
  end

  let(:custom_resource_class) do
    class_name = "#{test_run_id}TestCustomResource"
    Object.const_get(class_name)
  rescue NameError
    Object.const_set(
      class_name,
      Class.new(LedgerSync::Ledgers::TestLedger::Customer) do
        attribute :foo, type: LedgerSync::Type::String
      end
    )
  end

  let(:operation) do
    operation_class.new(
      client: client,
      resource: resource
    )
  end

  subject { operation }

  it { expect { described_class.new }.to raise_error(NoMethodError) } # Operation is a module

  describe '#deserializer' do
    it { expect(operation.deserializer).to be_a(LedgerSync::Ledgers::TestLedger::Customer::Deserializer) }
  end

  describe '#deserializer_class' do
    it { expect(operation.deserializer_class).to eq(LedgerSync::Ledgers::TestLedger::Customer::Deserializer) }
  end

  describe '#deserializer' do
    it do
      op = operation_class.new(
        client: test_ledger_client,
        resource: FactoryBot.create(:test_ledger_customer)
      )
      expect(op.deserializer).to be_a(LedgerSync::Ledgers::TestLedger::Customer::Deserializer)
    end
  end

  describe '#errors' do
    it { expect(operation.errors).to be_a(Dry::Validation::MessageSet) }
  end

  describe '#failure?' do
    it do
      subject.perform
      expect(subject).not_to be_failure
    end
  end

  describe '#perform' do
    subject { operation.perform }

    it do
      expect(subject).to be_success
    end

    it do
      allow(operation).to receive(:operate) { raise LedgerSync::Error.new(message: 'Test') }
      expect(subject).to be_failure
      expect(subject.error.message).to eq('Test')
    end

    it do
      operation.perform
      expect { operation.perform }.to raise_error(LedgerSync::Error::OperationError::PerformedOperationError)
    end
  end

  describe '#performed?' do
    it { expect(operation.performed?).to be_falsey }
  end

  describe '#resource' do
    it do
      op = operation_class.new(
        client: test_ledger_client,
        resource: FactoryBot.create(:test_ledger_customer)
      )
      expect(op.resource).to be_a(LedgerSync::Ledgers::TestLedger::Customer)
    end

    it do
      op = operation_class.new(
        client: test_ledger_client,
        resource: custom_resource_class.new
      )
      expect(op.resource).to be_a(custom_resource_class)
    end
  end

  describe '#serializer' do
    it do
      op = operation_class.new(
        client: test_ledger_client,
        resource: FactoryBot.create(:test_ledger_customer)
      )
      expect(op.serializer).to be_a(LedgerSync::Ledgers::TestLedger::Customer::Serializer)
    end
  end

  describe '#serializer' do
    it { expect(operation.serializer).to be_a(LedgerSync::Ledgers::TestLedger::Customer::Serializer) }
  end

  describe '#serializer_class' do
    it { expect(operation.serializer_class).to eq(LedgerSync::Ledgers::TestLedger::Customer::Serializer) }
  end

  describe '#success?' do
    it do
      subject.perform
      expect(subject).to be_success
    end
  end

  describe '#valid?' do
    it do
      subject.perform
      expect(subject).not_to be_valid
    end
  end

  describe '#validation_contract' do
    it do
      op = operation_class.new(
        client: test_ledger_client,
        resource: FactoryBot.create(:test_ledger_customer)
      )
      expect(op.validation_contract).to eq(operation_class::Contract)
    end

    it do
      op = operation_class.new(
        client: test_ledger_client,
        validation_contract: nil,
        resource: FactoryBot.create(:test_ledger_customer)
      )
      expect(op.validation_contract).to eq(operation_class::Contract)
    end

    it do
      op = operation_class.new(
        client: test_ledger_client,
        validation_contract: validation_contract,
        resource: FactoryBot.create(:test_ledger_customer)
      )
      expect(op.validation_contract).to eq(validation_contract)
    end

    it do
      expect do
        operation_class.new(
          client: test_ledger_client,
          validation_contract: 'asdf',
          resource: FactoryBot.create(:test_ledger_customer)
        )
      end.to raise_error(LedgerSync::Error::UnexpectedClassError)
    end
  end

  describe '.class_from' do
    it do
      expect(
        LedgerSync::Ledgers::Operation.class_from(
          client: test_ledger_client,
          method: :find,
          object: :customer
        )
      ).to eq(test_ledger_module::Customer::Operations::Find)
    end
  end

  describe '.client_class' do
    it do
      expect(
        operation.class.client_class
      ).to eq(test_ledger_client.class)
    end
  end

  describe '.operations_module' do
    it do
      expect(
        operation.class.operations_module
      ).to eq(test_ledger_module::Customer::Operations)
    end
  end
end
