# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DisplayHelper do
  let(:dummy_class) { Class.new { include DisplayHelper }.new }
  let(:title) { 'Client List' }
  let(:headings) { %w[full_name email] }

  describe '#display_table' do
    subject(:display_table) { dummy_class.display_table(title, headings, rows) }

    let(:fake_table) { instance_double(Terminal::Table) }

    before do
      allow(Terminal::Table).to receive(:new).and_return(fake_table)
      allow($stdout).to receive(:puts)
    end

    context 'when rows are present' do
      let(:rows) do
        [
          { 'full_name' => 'Alice Johnson', 'email' => 'alice@example.com' },
          { 'full_name' => 'Bob Smith', 'email' => 'bob@example.com' }
        ]
      end

      it 'builds and prints a formatted table with the correct title and data' do
        expect(Terminal::Table).to receive(:new).with(
          title: "#{title} (#{rows.size})",
          headings: headings,
          rows: rows.map(&:values)
        ).and_return(fake_table)

        expect($stdout).to receive(:puts).with(fake_table)
        display_table
      end
    end

    context 'when rows are empty' do
      let(:rows) { [] }

      it 'still prints an empty table with a count of 0' do
        expect(Terminal::Table).to receive(:new).with(
          title: "#{title} (0)",
          headings: headings,
          rows: []
        ).and_return(fake_table)

        expect($stdout).to receive(:puts).with(fake_table)
        display_table
      end
    end
  end

  describe '#field_error' do
    let(:store) { double('DataStore', available_fields: 'full_name, email') }

    it 'prints a clear error message with available fields' do
      expect($stdout).to receive(:puts).with('Invalid field. Try: full_name, email')
      dummy_class.field_error(store)
    end
  end
end
