# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Searcher do
  let(:data) do
    [
      { 'email' => 'alice@example.com', 'name' => 'Alice Johnson' },
      { 'email' => 'bob.smith@example.com', 'name' => 'Bob Smith' },
      { 'email' => 'charlie.samuel@example.com', 'name' => 'Charlie Samuel' },
      { 'email' => 'samuel.doe@example.com', 'name' => 'Samuel Doe' }
    ]
  end

  let(:searcher) { described_class.new(data, PartialMatch) }

  describe '#search' do
    context 'when some records match partially' do
      it 'returns all records containing the query (case insensitive)' do
        results = searcher.search('email', 'samuel')

        expect(results).to be_an(Array)
        expect(results.size).to eq(2)
        expect(results.map { |r| r['email'] }).to all(include('samuel'))
      end
    end

    context 'when no records match the query' do
      it 'returns an empty array' do
        results = searcher.search('email', 'unknown')

        expect(results).to eq([])
      end
    end

    context 'when the query is empty' do
      it 'returns all records' do
        results = searcher.search('email', '')

        expect(results).to eq(data)
      end
    end

    context 'when the field does not exist in the data' do
      it 'returns an empty array without raising an error' do
        expect { searcher.search('nonexistent_field', 'samuel') }
          .not_to raise_error

        results = searcher.search('nonexistent_field', 'samuel')
        expect(results).to eq([])
      end
    end

    context 'when field value is nil for some records' do
      it 'skips nil values and returns valid matches only' do
        data_with_nil = data + [{ 'email' => nil, 'name' => 'Ghost' }]
        searcher_with_nil = described_class.new(data_with_nil, PartialMatch)

        results = searcher_with_nil.search('email', 'samuel')

        expect(results.size).to eq(2)
        expect(results.map { |r| r['email'] }).to all(include('samuel'))
      end
    end

    context 'when data is empty' do
      it 'returns an empty array' do
        empty_searcher = described_class.new([], PartialMatch)
        results = empty_searcher.search('email', 'samuel')
        expect(results).to eq([])
      end
    end
  end
end
