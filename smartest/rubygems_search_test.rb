require "test_helper"

use_fixture PlaywrightFixture

test("rubygems.org で 'smartest' を検索すると YusukeIwaki の smartest が見つかる") do |page:|
  page.goto("https://rubygems.org/")

  page.locator("input[name='query']").first.fill("smartest")
  page.keyboard.press("Enter")

  page.wait_for_url(%r{/search})

  page.locator("a[href='/gems/smartest']").first.click
  page.wait_for_url("https://rubygems.org/gems/smartest")

  owner_href = page.locator("a[href^='/profiles/']").first.get_attribute("href")
  expect(owner_href).to eq("/profiles/YusukeIwaki")
end
