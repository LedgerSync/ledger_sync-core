# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LedgerSync::Ledgers::Request do
  let(:client) { test_ledger_client }
  let(:resource) { LedgerSync::Ledgers::TestLedger::Customer.new }

  subject do
    described_class.new(
      method: :get,
      url: 'http://www.example.com'
    )
  end

  describe '#body' do
    it { expect(described_class.new).to respond_to(:body) }
    it { expect(described_class.new(body: 'asdf').body).to eq('asdf') }
  end

  describe '#headers' do
    it { expect(described_class.new).to respond_to(:headers) }
    it { expect(described_class.new(headers: 'asdf').headers).to eq('asdf') }
  end

  describe '#method' do
    it { expect(described_class.new).to respond_to(:method) }
    it { expect(described_class.new(method: 'asdf').method).to eq('asdf') }
  end

  describe '#params' do
    it { expect(described_class.new).to respond_to(:params) }
    it { expect(described_class.new(params: 'asdf').params).to eq('asdf') }
  end

  describe '#perform' do
    it do
      stub_request(:get, "http://www.example.com/").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'User-Agent'=>'Ruby'
           }).
         to_return(status: 200, body: "", headers: {})

      subject.perform
      expect { subject.perform }.to raise_error(StandardError, 'Request already performed')
    end
  end

  describe '#url' do
    it { expect(described_class.new).to respond_to(:url) }
    it { expect(described_class.new(url: 'asdf').url).to eq('asdf') }
  end
end
