# smartest-playwright-example

[smartest](https://rubygems.org/gems/smartest) と [playwright-ruby-client](https://github.com/YusukeIwaki/playwright-ruby-client) を組み合わせて、ブラウザ自動操作テストを書く最小サンプルです。

rubygems.org のトップページから "smartest" を検索し、検索結果の gem 詳細ページに表示されるオーナーが `YusukeIwaki` であることを確認します。

## 必要な環境

- Ruby 3.1+ (smartest 0.1.0.alpha1 の `required_ruby_version`)
- Node.js (playwright CLI を呼び出すため)
- bundler

## セットアップ

Ruby 側の依存をインストール:

```bash
bundle install
```

Playwright CLI と Chromium を取得:

```bash
npm install playwright
npx playwright install chromium
```

## テストの実行

```bash
bundle exec smartest
```

成功時の出力:

```
Running 1 test
✓ rubygems.org で 'smartest' を検索すると YusukeIwaki の smartest が見つかる
1 test, 1 passed, 0 failed
```

## ファイル構成

```
.
├── Gemfile                                 # smartest, playwright-ruby-client
├── package.json                            # playwright (npm)
└── smartest/
    ├── test_helper.rb                      # smartest/autorun と fixtures の読み込み
    ├── fixtures/
    │   └── playwright_fixture.rb           # Playwright 起動と Page 生成のフィクスチャ
    └── rubygems_search_test.rb             # rubygems.org 検索テスト
```

## 仕組み

`PlaywrightFixture` は以下のスコープで Playwright のリソースを管理します。

- `suite_fixture :playwright` — テストスイート全体で 1 度だけ Playwright ランタイムを起動し、終了時に `runtime.stop` を呼ぶ
- `suite_fixture :browser` — Chromium を 1 回だけ launch し、終了時に `browser.close`
- `fixture :page` — テストごとに新しい `BrowserContext` を作り、その上で `Page` を発行(テスト間の Cookie / ストレージを分離)

テストはキーワード引数 `|page:|` で必要なフィクスチャだけを宣言的に受け取ります。

## 参考

- smartest ドキュメント: https://smartest-rb.vercel.app/
- playwright-ruby-client: https://github.com/YusukeIwaki/playwright-ruby-client
