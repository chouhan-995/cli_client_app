# Client Tool – Ruby CLI App

A command-line application built with **Ruby**, designed to:

1. **Search** client records by any given field (e.g. full_name, email)
2. **Detect** duplicate values in any field (e.g. duplicate emails)

This tool is built with **TDD (Test-Driven Development)** and follows SOLID principles, making it easy to scale and maintain.

---

## 🚀 Setup

### Prerequisites

- Ruby 3.x
- Bundler (`gem install bundler`)
- JSON file (e.g., `clients.json`) in the project root

### Install dependencies

```bash
bundle install
```

---

## Running the App

  - Just run `bundle exec ruby client_cli.rb [filepath]`
  - To search in existing JSON data:
  `bundle exec ruby client_cli.rb`
  - To search by passing JSON file:
  `bundle exec ruby client_cli.rb clients.json`
  - To find duplicates in existing JSON data:
  `bundle exec ruby client_cli.rb`
  - To find duplicates by passing JSON file:
  `bundle exec ruby client_cli.rb clients.json`

You’ll be prompted to:
  Choose an option:
  1. **Search clients** by any field
  2. **Find duplicates** in a field (like `email`)
  3. **Exit** by entering 3

---

## Features

### Search Clients

- Choose any field (e.g., full_name, email)
- Field-based, case-insensitive, partial match.
- Prompts for a valid field and search term.
- Displays results in a clean terminal table.

### Find Duplicates

- Choose any field (e.g., full_name, email)
- Detects and displays all records with duplicate values in that field.

---

## Test Coverage

TDD was followed from the start. To run tests:

```bash
bundle exec rspec spec/
```

Specs cover:

- Data loading (`DataStore`)
- Searching logic (`Searcher`, `PartialSearch`)
- Duplicate detection (`DuplicateChecker`)

---

## Future Improvements

- Convert to a REST API
- Add fuzzy/regex search support
- Paginate results for large datasets
- Better handling for malformed JSON

---

## Design Notes

The `SearchStrategy` design allows for easy extension of search logic without modifying existing code.

- **SRP**: Each class has one responsibility.
- **OCP**: Easily add new strategies.
- **LSP**: Strategies are swappable without breaking behavior.
