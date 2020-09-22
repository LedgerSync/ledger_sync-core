# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LedgerSync do
  it 'has a version number' do
    expect(LedgerSyncCore::VERSION).not_to be(nil)
  end
end
