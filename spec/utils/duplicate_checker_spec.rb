# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DuplicateChecker do
  let(:data) do
    [
      { 'email' => 'alice@example.com', 'name' => 'Alice' },
      { 'email' => 'bob@example.com', 'name' => 'Bob' },
      { 'email' => 'alice@example.com', 'name' => 'Charlie' },
      { 'email' => nil, 'name' => 'Dana' }
    ]
  end

  describe '.call' do
    context 'when duplicates exist in the specified field' do
      it 'returns a hash grouped by the duplicated value' do
        result = described_class.call(data, 'email')

        expect(result).to be_a(Hash)
        expect(result).to have_key('alice@example.com')
        expect(result['alice@example.com'].size).to eq(2)
      end
    end

    context 'when there are no duplicates' do
      it 'returns an empty hash' do
        result = described_class.call(data, 'name')

        expect(result).to eq({})
      end
    end

    context 'when the field does not exist' do
      it 'returns a hash with nil key and all records' do
        result = described_class.call(data, 'nonexistent_field')

        expect(result).to be_a(Hash)
        expect(result.keys).to eq([nil])
        expect(result[nil].size).to eq(4)
      end
    end

    context 'when given an empty dataset' do
      it 'returns an empty hash' do
        result = described_class.call([], 'email')

        expect(result).to eq({})
      end
    end

    context 'when all records share the same value' do
      it 'returns all records grouped under that single value' do
        identical_data = Array.new(3) { { 'email' => 'same@example.com', 'name' => 'Test' } }
        result = described_class.call(identical_data, 'email')

        expect(result.keys).to eq(['same@example.com'])
        expect(result['same@example.com'].size).to eq(3)
      end
    end
  end
end
