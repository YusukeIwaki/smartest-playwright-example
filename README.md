# smartest-playwright-example

A minimal example that combines [smartest](https://rubygems.org/gems/smartest) with [playwright-ruby-client](https://github.com/YusukeIwaki/playwright-ruby-client) to drive a real browser from a Ruby test suite.

The single test opens rubygems.org, searches for `smartest`, follows the result to the gem detail page, and verifies that the gem is owned by `YusukeIwaki`.

## Requirements

- Ruby 3.1+ (smartest 0.1.0.alpha1 declares `required_ruby_version >= 3.1`)
- Node.js (playwright-ruby-client invokes the Playwright CLI)
- Bundler

## Setup

Install the Ruby dependencies:

```bash
bundle install
```

Install the Playwright CLI and download Chromium:

```bash
npm install playwright
npx playwright install chromium
```

## Run the test

```bash
bundle exec smartest
```

Expected output:

```
Running 1 test
✓ rubygems.org で 'smartest' を検索すると YusukeIwaki の smartest が見つかる
1 test, 1 passed, 0 failed
```

## Project layout

```
.
├── Gemfile                                 # smartest, playwright-ruby-client
├── package.json                            # playwright (npm) — provides the Playwright CLI
└── smartest/
    ├── test_helper.rb                      # loads smartest/autorun and every file under fixtures/
    ├── fixtures/
    │   └── playwright_fixture.rb           # Playwright runtime, browser, and page fixtures
    └── rubygems_search_test.rb             # the rubygems.org search test
```

## How it works

`PlaywrightFixture` manages the Playwright resources at three different scopes:

- `suite_fixture :playwright` — starts the Playwright runtime once per suite and calls `runtime.stop` on cleanup.
- `suite_fixture :browser` — launches Chromium once per suite and closes it on cleanup.
- `fixture :page` — creates a fresh `BrowserContext` for every test (so cookies and storage are isolated) and returns a new `Page` on top of it.

Tests declare which fixtures they need through keyword arguments. For example:

```ruby
test("...") do |page:|
  page.goto("https://rubygems.org/")
  # ...
end
```

smartest resolves `page:` against the registered fixtures, and the dependency chain `page → browser → playwright` is wired up automatically.

## References

- smartest documentation: https://smartest-rb.vercel.app/
- playwright-ruby-client: https://github.com/YusukeIwaki/playwright-ruby-client
