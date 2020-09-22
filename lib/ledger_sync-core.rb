# frozen_string_literal: true

require 'json'
require 'dry-schema'
require 'dry-validation'
require 'logger'
require 'resonad'
require 'rack'
require 'faraday'
require 'uri'
require 'colorize'
require 'fingerprintable'
require 'simply_serializable'
require 'active_model'
require 'tempfile'
require 'pd_ruby'

# Dotenv
require 'dotenv'
Dotenv.load

# Version
require 'ledger_sync-core/version'

# Concerns
require 'ledger_sync-core/concerns/validatable'

# Extensions
require 'ledger_sync-core/core_ext/resonad'

# Errors
require 'ledger_sync-core/error'
Gem.find_files('ledger_sync-core/error/**/*.rb').each { |path| require path }

# Support Classes
require 'ledger_sync-core/util/resonad'
require 'ledger_sync-core/util/url_helpers'
require 'ledger_sync-core/util/signer'
require 'ledger_sync-core/util/hash_helpers'
require 'ledger_sync-core/util/read_only_object'
require 'ledger_sync-core/util/resources_builder'
require 'ledger_sync-core/ledger_configuration'
require 'ledger_sync-core/ledger_configuration_store'
require 'ledger_sync-core/util/performer'
require 'ledger_sync-core/util/validator'
require 'ledger_sync-core/util/string_helpers'
require 'ledger_sync-core/util/mixins/delegate_iterable_methods_mixin'
require 'ledger_sync-core/util/mixins/resource_registerable_mixin'
require 'ledger_sync-core/util/mixins/dupable_mixin'
require 'ledger_sync-core/result'
require 'ledger_sync-core/operation'

Gem.find_files('ledger_sync-core/type/**/*.rb').each { |path| require path }
Gem.find_files('ledger_sync-core/serialization/type/**/*.rb').each { |path| require path }
require 'ledger_sync-core/serializer'
require 'ledger_sync-core/deserializer'

# Ledgers
Gem.find_files('ledger_sync-core/ledgers/mixins/**/*.rb').each { |path| require path }
require 'ledger_sync-core/ledgers/client'
require 'ledger_sync-core/ledgers/dashboard_url_helper'
require 'ledger_sync-core/ledgers/searcher'
require 'ledger_sync-core/ledgers/operation'
require 'ledger_sync-core/ledgers/contract'
require 'ledger_sync-core/ledgers/response'
require 'ledger_sync-core/ledgers/request'

# Resources (resources are registered below)
require 'ledger_sync-core/resource' # Template class

module LedgerSync
  include Util::Mixins::ResourceRegisterableMixin

  @log_level = nil
  @logger = nil

  # map to the same values as the standard library's logger
  LEVEL_DEBUG = Logger::DEBUG
  LEVEL_ERROR = Logger::ERROR
  LEVEL_INFO = Logger::INFO

  def self.ledgers
    @ledgers ||= LedgerSync::LedgerConfigurationStore.new
  end

  def self.log_level
    @log_level
  end

  def self.log_level=(val)
    if !val.nil? && ![LEVEL_DEBUG, LEVEL_ERROR, LEVEL_INFO].include?(val)
      raise ArgumentError, 'log_level should only be set to `nil`, `debug` or `info`'
    end

    @log_level = val
  end

  def self.logger
    @logger
  end

  def self.logger=(val)
    @logger = val
  end

  def self.register_ledger(*args)
    ledger_config = LedgerSync::LedgerConfiguration.new(*args)

    require ledger_config.client_path

    yield(ledger_config)

    ledgers.register_ledger(ledger_config: ledger_config)

    client_files = Gem.find_files("#{ledger_config.root_path}/resource.rb")
    client_files |= Gem.find_files("#{ledger_config.root_path}/resources/**/*.rb")
    client_files |= Gem.find_files("#{ledger_config.root_path}/serialization/**/*.rb")
    # Sort the files to include BFS-style as most dependencies are in parent folders
    client_files |= Gem.find_files("#{ledger_config.root_path}/**/*.rb").sort { |a, b| a.count('/') <=> b.count('/') }

    client_files.each do |path|
      next if path.include?('config.rb')

      require path
    end
  end

  def self.root
    File.dirname __dir__
  end
end

# Load Ledgers
Gem.find_files('ledger_sync-core/ledgers/**/config.rb').each { |path| require path }
