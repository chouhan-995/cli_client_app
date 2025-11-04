# frozen_string_literal: true

class Searcher
  def initialize(data, strategy_module)
    @data = data
    extend strategy_module
  end
end
