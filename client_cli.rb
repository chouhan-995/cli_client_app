# frozen_string_literal: true

require_relative './lib/data_store'
require_relative './lib/client_interface'

file_path = ARGV.shift || 'clients.json'

DataStore.instance.load(file_path)
ClientInterface.new.run
