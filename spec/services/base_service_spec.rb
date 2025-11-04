# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BaseService do
  let(:data) { [{ 'name' => 'Alice' }] }
  let(:fields) { %w[name email] }
  let(:store) { double('DataStore') }
  let(:service) { described_class.new(data: data, fields: fields, store: store) }

  describe '#initialize' do
    it 'assigns data, fields, and store correctly' do
      expect(service.data).to eq(data)
      expect(service.fields).to eq(fields)
      expect(service.store).to eq(store)
    end
  end

  describe '#call' do
    it 'raises NotImplementedError when called directly' do
      expect { service.call }.to raise_error(NotImplementedError, 'Subclasses must implement the call method')
    end
  end
end
