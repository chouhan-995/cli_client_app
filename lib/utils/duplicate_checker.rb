# frozen_string_literal: true

class DuplicateChecker
  def self.call(data, field)
    data.group_by { |item| item[field] }
        .select { |_key, records| records.size > 1 }
  end
end
