# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PartialMatch do
  let(:data) do
    [
      { 'full_name' => 'John Doe', 'email' => 'john@example.com' },
      { 'full_name' => 'Jane Smith', 'email' => 'jane@example.com' },
      { 'full_name' => 'Johnny Appleseed', 'email' => 'johnny@apple.com' }
    ]
  end

  let(:searcher) do
    obj = Object.new
    obj.extend(PartialMatch)
    obj.instance_variable_set(:@data, data)
    obj
  end

  describe '#search' do
    it 'returns matching records for partial name' do
      result = searcher.search('full_name', 'john')

      expect(result.map { |r| r['full_name'] }).to contain_exactly('John Doe', 'Johnny Appleseed')
    end

    it 'is case-insensitive when searching' do
      result = searcher.search('email', 'JOHN@EXAMPLE.COM')

      expect(result.first['email']).to eq('john@example.com')
    end

    it 'returns an empty array if nothing matches' do
      result = searcher.search('full_name', 'xyz')

      expect(result).to eq([])
    end

    it 'ignores nil values gracefully' do
      data << { 'full_name' => nil }
      result = searcher.search('full_name', 'john')

      expect(result).not_to include({ 'full_name' => nil })
    end
  end
end
