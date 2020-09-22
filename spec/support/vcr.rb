# frozen_string_literal: true

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!

  config.debug_logger = File.open(File.join(LedgerSync.root, 'tmp/vcr.log'), 'w') if ENV['DEBUG']

  if ENV.key?('USE_DOTENV_ADAPTOR_SECRETS')
    test_ledger_account_id_filler = 'vcr_test_ledger_account_id'
    # These need to match the defaults in support/test_ledger_helpers.rb for the
    # stubs to work.
    if ENV.key?('TEST_LEDGER_ACCESS_TOKEN')
      config.filter_sensitive_data('VCR_TEST_LEDGER_ACCESS_TOKEN') { ENV['TEST_LEDGER_ACCESS_TOKEN'] }
    end
    if ENV.key?('TEST_LEDGER_CLIENT_ID')
      config.filter_sensitive_data('VCR_TEST_LEDGER_CLIENT_ID') { ENV['TEST_LEDGER_CLIENT_ID'] }
    end
    if ENV.key?('TEST_LEDGER_CLIENT_SECRET')
      config.filter_sensitive_data('VCR_TEST_LEDGER_CLIENT_SECRET') { ENV['TEST_LEDGER_CLIENT_SECRET'] }
    end
    if ENV.key?('TEST_LEDGER_REALM_ID')
      config.filter_sensitive_data('VCR_TEST_LEDGER_REALM_ID') { ENV['TEST_LEDGER_REALM_ID'] }
    end
    if ENV.key?('TEST_LEDGER_REFRESH_TOKEN')
      config.filter_sensitive_data('VCR_TEST_LEDGER_REFRESH_TOKEN') { ENV['TEST_LEDGER_REFRESH_TOKEN'] }
    end
  end
end

RSpec.configure do |config|
  config.around(:each) do |ex|
    if ex.metadata.key?(:vcr) && ex.metadata[:vcr] != false && !ex.metadata[:qa]
      ex.run
    else
      VCR.turned_off { ex.run }
    end
  end
end
