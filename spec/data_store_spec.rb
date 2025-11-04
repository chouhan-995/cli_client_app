# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DataStore do
  let(:data_store) { described_class.instance }

  describe '#load' do
    let(:file_path) { 'clients.json' }

    context 'when a valid JSON file is provided' do
      let(:sample_data) do
        [
          { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john@example.com' },
          { 'id' => 2, 'full_name' => 'Jane Doe', 'email' => 'jane@example.com' }
        ]
      end

      before do
        File.write(file_path, sample_data.to_json)
        data_store.load(file_path)
      end

      it 'loads data successfully' do
        expect(data_store.data).to be_an(Array)
        expect(data_store.data.size).to eq(2)
      end

      it 'extracts all field names correctly' do
        expect(data_store.fields).to contain_exactly('id', 'full_name', 'email')
      end

      it 'excludes the "id" field from available fields' do
        expect(data_store.available_fields).to be_a(Array)
        expect(data_store.available_fields).to include('full_name', 'email')
        expect(data_store.available_fields).not_to include('id')
      end

      it 'formats available fields as a comma-separated string' do
        expect(data_store.available_fields).to match(%w[full_name email])
      end
    end

    context 'when the file does not exist' do
      it 'prints an error message and does not raise an exception' do
        expect do
          data_store.load('non_existing_file.json')
        end.to output(/Error loading file:/).to_stdout
      end
    end

    context 'when the file contains invalid JSON' do
      let(:invalid_path) { 'invalid.json' }

      before { File.write(invalid_path, '{ invalid_json }') }
      after { File.delete(invalid_path) if File.exist?(invalid_path) }

      it 'prints an error message for invalid JSON content' do
        expect { data_store.load(invalid_path) }
          .to output(/Error loading file:/).to_stdout
      end
    end
  end
end
