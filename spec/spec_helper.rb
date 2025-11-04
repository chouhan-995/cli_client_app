# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'rspec'
require 'data_store'
require 'searcher'
require 'modules/partial_match'
require 'utils/duplicate_checker'
require 'client_interface'
require 'services/search_service'
require 'services/duplicate_service'
require 'terminal-table'
