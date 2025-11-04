# frozen_string_literal: true

require_relative './base_service'
require_relative '../utils/display_helper'
require_relative '../searcher'
require_relative '../modules/partial_match'

class SearchService < BaseService
  def call
    field = select_field
    return :exit_after_display unless field

    query = prompt_query
    results = perform_search(field, query)
    return display_no_results_message if results.empty?

    display_table('Search Results', @store.fields, results)
    :exit_after_display
  end

  private

  def select_field
    puts "\nSearch by:"
    @fields.each_with_index { |field, index| puts "#{index + 1}. #{field}" }
    print 'Enter your choice (number): '

    input = gets.chomp
    choice = input.to_i

    unless input.match?(/^\d+$/) && choice.between?(1, @fields.size)
      puts 'Invalid choice! Please enter 1 or 2.'
      return nil
    end

    @fields[choice - 1]
  end

  def prompt_query
    print 'Enter search term: '
    gets.chomp.strip
  end

  def perform_search(field, query)
    searcher = Searcher.new(@data, PartialMatch)
    searcher.search(field, query)
  end

  def display_no_results_message
    puts "\nNo results found."
    :exit_after_display
  end
end
