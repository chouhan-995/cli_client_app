# frozen_string_literal: true

require 'terminal-table'

module DisplayHelper
  def display_table(title, headings, rows)
    puts Terminal::Table.new(
      title: "#{title} (#{rows.size})",
      headings: headings,
      rows: rows.map(&:values)
    )
  end

  def field_error(store)
    puts "Invalid field. Try: #{store.available_fields}"
  end
end
