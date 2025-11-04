# frozen_string_literal: true

require_relative './base_service'
require_relative '../utils/display_helper'
require_relative '../utils/duplicate_checker'

class DuplicateService < BaseService
  def call
    field = select_field
    return :exit_after_display unless field

    results = DuplicateChecker.call(@data, field)
    puts results
    return display_no_duplicates_message if results.empty?

    display_duplicates(field, results)
    :exit_after_display
  end

  private

  def select_field
    puts "\nCheck duplicates by:"
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

  def display_no_duplicates_message
    puts "\nNo duplicates found."

    :exit_after_display
  end

  def display_duplicates(field, results)
    puts "\nDuplicate #{field}s found:\n"
    results.each do |value, records|
      display_table("#{field.capitalize}: #{value}", @store.fields, records)
    end
  end
end
