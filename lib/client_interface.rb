# frozen_string_literal: true

require_relative './data_store'
require_relative './searcher'
require_relative './utils/duplicate_checker'
require_relative './modules/partial_match'
require_relative './services/search_service'
require_relative './services/duplicate_service'

class ClientInterface
  attr_reader :data, :fields, :store

  def initialize
    @store = DataStore.instance
    @data = @store.data
    @fields = @store.available_fields
  end

  def run
    return puts 'No data loaded.' if data.empty?

    loop do
      display_menu
      choice = gets.chomp.downcase
      break if handle_choice(choice)
    end
  end

  private

  def handle_choice(choice)
    case choice
    when '1' then run_service(SearchService)
    when '2' then run_service(DuplicateService)
    when '3', 'exit'
      puts 'Goodbye!'
      true
    else
      puts 'Invalid choice! Please enter 1, 2, or 3.'
      false
    end
  end

  def run_service(service_class)
    result = service_class.new(data: data, fields: fields, store: store).call
    result == :exit_after_display
  end

  def display_menu
    puts
    puts 'Choose an option:'
    puts '1. Search clients'
    puts '2. Find duplicate entries'
    puts '3. Exit'
    print 'Enter your choice (1, 2, or 3): '
  end
end
