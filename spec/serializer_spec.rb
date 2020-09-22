# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LedgerSync::Serializer do
  let(:test_serializer_class) do
    Class.new(LedgerSync::Serializer) do
      attribute :name
      attribute :phone_number
      attribute :email, if: :email_present?

      def email_present?(args = {})
        resource = args.fetch(:resource)

        resource.email.present?
      end
    end
  end

  let(:custom_serializer_class) do
    Class.new(LedgerSync::Serializer) do
      attribute :foo,
                resource_attribute: :foo
    end
  end

  let(:test_serializer) do
    test_serializer_class.new
  end

  let(:test_resource) do
    custom_resource_class.new(
      name: 'test_name',
      phone_number: 'test_phone',
      email: 'test_email'
    )
  end

  let(:custom_resource_class) do
    new_resource_class(
      attributes: %i[
        foo
        type
        name
        phone_number
        email
      ]
    )
  end

  it { expect(described_class).to respond_to(:attribute) }
  it { expect(described_class).to respond_to(:references_many) }
  it { expect(described_class).to respond_to(:references_one) }

  describe '#serialize' do
    it do
      h = {
        'email' => 'test_email',
        'name' => 'test_name',
        'phone_number' => 'test_phone'
      }
      expect(test_serializer.serialize(resource: test_resource)).to eq(h)
    end

    context 'if method' do
      it do
        test_resource.email = nil
        expect(test_serializer.serialize(resource: test_resource)).not_to have_key('email')
      end
    end

    context 'only_changes' do
      it do
        resource = custom_resource_class.new
        serializer = test_serializer_class.new

        expect(serializer.serialize(only_changes: true, resource: resource)).to eq({})
        resource.name = 'Testing'
        expect(serializer.serialize(only_changes: true, resource: resource)).to eq('name' => 'Testing')
      end
    end

    it 'allows multiple values in nested hash' do
      resource_class = new_resource_class(
        attributes: %i[
          entry_type
        ],
        references_one: %i[
          account
          ledger_class
          department
        ]
      )

      resource = resource_class.new(
        entry_type: 'debit',
        account: LedgerSync::Resource.new(
          ledger_id: 'adsf'
        ),
        ledger_class: LedgerSync::Resource.new(
          ledger_id: 'asdf'
        ),
        department: LedgerSync::Resource.new(
          ledger_id: 'asdf'
        )
      )

      serializer_class = Class.new(LedgerSync::Serializer) do
        attribute 'JournalEntryLineDetail.AccountRef.value',
                  resource_attribute: 'account.ledger_id'

        attribute 'JournalEntryLineDetail.ClassRef.value',
                  resource_attribute: 'ledger_class.ledger_id'
      end

      h = {
        'JournalEntryLineDetail' => {
          'AccountRef' => {
            'value' => 'adsf'
          },
          'ClassRef' => {
            'value' => 'asdf'
          }
        }
      }

      expect(serializer_class.new.serialize(resource: resource)).to eq(h)
    end

    context 'with custom attributes' do
      let(:test_resource) { custom_resource_class.new(foo: 'asdf') }
      let(:test_serializer) do
        custom_serializer_class.new
      end

      it do
        h = {
          'foo' => 'asdf'
        }

        expect(test_serializer.serialize(resource: test_resource)).to eq(h)
      end
    end
  end
end
