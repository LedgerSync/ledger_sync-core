# frozen_string_literal: true

require 'spec_helper'

support :serializable_shared_examples

RSpec.describe LedgerSync::Resource, type: :serializable do
  let(:customer) { LedgerSync::Ledgers::TestLedger::Customer.new(name: 'John Doe') }

  def new_resource
    LedgerSync::Ledgers::TestLedger::Customer.new(name: 'A New Name')
  end

  subject { customer.serialize }

  it_behaves_like 'a serializable object'
end
