# frozen_string_literal: true

require 'spec_helper'

RSpec.describe SearchService do
  let(:store) { double('DataStore', fields: %w[full_name email]) }

  let(:data) do
    [
      { 'full_name' => 'Alice Johnson', 'email' => 'alice@example.com' },
      { 'full_name' => 'Bob Smith', 'email' => 'bob@example.com' }
    ]
  end

  subject(:service) { described_class.new(data: data, fields: store.fields, store: store) }

  let(:fake_searcher) { double('Searcher') }

  before do
    allow($stdout).to receive(:puts)
    allow($stdout).to receive(:print)
    allow(Searcher).to receive(:new).and_return(fake_searcher)
  end

  describe '#call' do
    context 'when user selects Full Name and matching results exist' do
      it 'displays the search results in a table' do
        allow(service).to receive(:gets).and_return("1\n", "Alice\n")
        allow(fake_searcher).to receive(:search).with('full_name', 'Alice').and_return([data.first])

        expect(service).to receive(:display_table)
          .with('Search Results', store.fields, [data.first])

        expect(service.call).to eq(:exit_after_display)
        expect(Searcher).to have_received(:new).with(data, PartialMatch)
      end
    end

    context 'when user selects Email but no matches found' do
      it 'prints "No results found."' do
        allow(service).to receive(:gets).and_return("2\n", "notfound@example.com\n")
        allow(fake_searcher).to receive(:search).and_return([])

        expect($stdout).to receive(:puts).with("\nNo results found.")
        expect(service.call).to eq(:exit_after_display)
      end
    end

    context 'when user enters an invalid numeric choice' do
      it 'prints invalid choice message and exits' do
        allow(service).to receive(:gets).and_return("9\n")

        expect($stdout).to receive(:puts).with('Invalid choice! Please enter 1 or 2.')
        expect(service.call).to eq(:exit_after_display)
      end
    end

    context 'when user enters a non-numeric choice' do
      it 'prints invalid choice message and exits' do
        allow(service).to receive(:gets).and_return("abc\n")

        expect($stdout).to receive(:puts).with('Invalid choice! Please enter 1 or 2.')
        expect(service.call).to eq(:exit_after_display)
      end
    end

    context 'when the user enters an empty search term' do
      it 'handles empty query gracefully and still searches' do
        allow(service).to receive(:gets).and_return("1\n", "\n")
        allow(fake_searcher).to receive(:search).with('full_name', '').and_return([])

        expect($stdout).to receive(:puts).with("\nNo results found.")
        expect(service.call).to eq(:exit_after_display)
      end
    end
  end
end
