class PlaywrightFixture < Smartest::Fixture
  suite_fixture :playwright do
    runtime = Playwright.create(
      playwright_cli_executable_path: "./node_modules/.bin/playwright",
    )
    cleanup { runtime.stop }
    runtime.playwright
  end

  suite_fixture :browser do |playwright:|
    browser = playwright.chromium.launch(headless: true)
    cleanup { browser.close }
    browser
  end

  fixture :page do |browser:|
    context = browser.new_context
    cleanup { context.close }
    context.new_page
  end
end
