# frozen_string_literal: true

require_relative '../utils/display_helper'

class BaseService
  include DisplayHelper

  attr_reader :data, :fields, :store

  def initialize(data:, fields:, store:)
    @data = data
    @fields = fields
    @store = store
  end

  def call
    raise NotImplementedError, 'Subclasses must implement the call method'
  end
end
