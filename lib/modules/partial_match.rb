# frozen_string_literal: true

module PartialMatch
  def search(field, query)
    @data.select { |item| item[field]&.downcase&.include?(query.downcase) }
  end
end
