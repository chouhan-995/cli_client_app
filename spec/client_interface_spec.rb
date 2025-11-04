# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ClientInterface do
  let(:store) { double('DataStore', data: data, fields: fields, available_fields: fields) }
  let(:data) { [{ 'name' => 'Alice' }, { 'name' => 'Bob' }] }
  let(:fields) { ['name'] }
  let(:client_tool) { described_class.new }

  before do
    allow(DataStore).to receive(:instance).and_return(store)
    stub_const('SearchService', Class.new)
    stub_const('DuplicateService', Class.new)
  end

  describe '#initialize' do
    it 'loads data and fields from the DataStore' do
      expect(client_tool.store).to eq(store)
      expect(client_tool.data).to eq(data)
      expect(client_tool.fields).to eq(fields)
    end
  end

  describe '#run' do
    context 'when no data is loaded' do
      let(:data) { [] }

      it 'prints a message and exits' do
        expect { client_tool.run }.to output(/No data loaded/).to_stdout
      end
    end

    context 'when data is loaded' do
      let(:return_values) { [] }

      before do
        allow(client_tool).to receive(:display_menu)
        allow(client_tool).to receive(:gets).and_return(*return_values)
      end

      context 'when option 1 is chosen' do
        let(:return_values) { %w[1 3] }

        it 'calls SearchService' do
          search_service = instance_double('SearchService', call: nil)
          allow(SearchService).to receive(:new)
            .with(data: data, fields: fields, store: store)
            .and_return(search_service)

          expect(search_service).to receive(:call)
          client_tool.run
        end
      end

      context 'when option 2 is chosen' do
        let(:return_values) { %w[2 3] }

        it 'calls DuplicateService' do
          duplicate_service = instance_double('DuplicateService', call: nil)
          allow(DuplicateService).to receive(:new)
            .with(data: data, fields: fields, store: store)
            .and_return(duplicate_service)

          expect(duplicate_service).to receive(:call)
          client_tool.run
        end
      end

      context 'when option 3 is chosen' do
        let(:return_values) { ['3'] }

        it 'prints goodbye and exits' do
          expect { client_tool.run }.to output(/Goodbye!/).to_stdout
        end
      end

      context 'when invalid input is entered' do
        let(:return_values) { %w[invalid 3] }

        it 'prints invalid choice message' do
          expect { client_tool.run }.to output(/Invalid choice!/).to_stdout
        end
      end

      context 'when a service returns :exit_after_display' do
        let(:return_values) { ['1'] }

        it 'exits after display' do
          service = instance_double('SearchService', call: :exit_after_display)
          allow(SearchService).to receive(:new).and_return(service)

          expect(service).to receive(:call)
          client_tool.run
        end
      end
    end
  end

  describe '#display_menu' do
    it 'prints the options to stdout' do
      expected_output = <<~MENU.chomp
        \nChoose an option:
        1. Search clients
        2. Find duplicate entries
        3. Exit
        Enter your choice (1, 2, or 3):#{' '}
      MENU

      expect { client_tool.send(:display_menu) }.to output(expected_output).to_stdout
    end
  end
end
