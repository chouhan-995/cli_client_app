# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DuplicateService do
  let(:data) do
    [
      { 'full_name' => 'Alice Johnson', 'email' => 'alice@example.com' },
      { 'full_name' => 'Bob Smith', 'email' => 'bob@example.com' },
      { 'full_name' => 'Alice Johnson', 'email' => 'alice.dup@example.com' },
      { 'full_name' => 'Carol Lee', 'email' => 'carol@example.com' },
      { 'full_name' => 'Bob Smith', 'email' => 'bob@example.com' }
    ]
  end

  let(:store) { double('DataStore', fields: %w[full_name email]) }
  let(:service) { described_class.new(data: data, fields: store.fields, store: store) }
  let(:output) { StringIO.new }

  before do
    allow($stdout).to receive(:puts) { |msg| output.puts(msg) }
  end

  describe '#call' do
    shared_examples 'duplicate display' do |choice, field, fake_result|
      it "handles duplicates for #{field}" do
        allow(service).to receive(:gets).and_return(choice)
        allow(DuplicateChecker).to receive(:call).and_return(fake_result)
        allow(service).to receive(:display_table)

        result = service.call

        expect(result).to eq(:exit_after_display)
        expect(DuplicateChecker).to have_received(:call).with(data, field)
        fake_result.each do |value, records|
          expect(service).to have_received(:display_table).with(
            "#{field.capitalize}: #{value}", store.fields, records
          )
        end
      end
    end

    context 'when user selects full_name' do
      include_examples 'duplicate display', '1', 'full_name',
                       {
                         'Alice Johnson' => [
                           { 'full_name' => 'Alice Johnson', 'email' => 'alice@example.com' },
                           { 'full_name' => 'Alice Johnson', 'email' => 'alice.dup@example.com' }
                         ]
                       }
    end

    context 'when user selects email' do
      include_examples 'duplicate display', '2', 'email',
                       {
                         'bob@example.com' => [
                           { 'full_name' => 'Bob Smith', 'email' => 'bob@example.com' },
                           { 'full_name' => 'Bob Smith', 'email' => 'bob@example.com' }
                         ]
                       }
    end

    context 'when no duplicates are found' do
      it 'prints a message and exits cleanly' do
        allow(service).to receive(:gets).and_return('1')
        allow(DuplicateChecker).to receive(:call).and_return({})

        result = service.call

        expect(result).to eq(:exit_after_display)
        expect(output.string).to include('No duplicates found')
      end
    end

    context 'when user enters an invalid choice' do
      it 'prints an error message and exits gracefully' do
        allow(service).to receive(:gets).and_return('5')

        result = service.call

        expect(result).to eq(:exit_after_display)
        expect(output.string).to include('Invalid choice! Please enter 1 or 2.')
      end
    end

    context 'when there are multiple duplicate groups' do
      it 'displays each duplicate group separately' do
        allow(service).to receive(:gets).and_return('1')
        fake_result = {
          'Alice Johnson' => [
            { 'full_name' => 'Alice Johnson', 'email' => 'alice@example.com' },
            { 'full_name' => 'Alice Johnson', 'email' => 'alice.dup@example.com' }
          ],
          'Bob Smith' => [
            { 'full_name' => 'Bob Smith', 'email' => 'bob@example.com' },
            { 'full_name' => 'Bob Smith', 'email' => 'bob@example.com' }
          ]
        }

        allow(DuplicateChecker).to receive(:call).and_return(fake_result)
        allow(service).to receive(:display_table)

        result = service.call

        expect(result).to eq(:exit_after_display)
        expect(service).to have_received(:display_table).twice
      end
    end
  end
end
