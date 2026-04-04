---
name: pmbok-github-report
description: |
  GitHub Projects のデータからステークホルダー向けレポートを自動生成する。
  週報・日報テンプレート、進捗サマリ、EV指標の定期レポートを構築する。
  Use when 週報・日報の自動生成、進捗報告、ステークホルダー向けレポート、
  プロジェクトサマリの作成が必要な場合。
---

# PMBOK GitHub Report

GitHub Projects のデータからプロジェクトレポートを自動生成する。

## このスキルを使用する場面

- 週報・日報を GitHub データから自動生成する
- ステークホルダー向けの進捗サマリを作成する
- EV 指標の定期レポートを構築する
- マイルストーン進捗の可視化レポートを生成する

## 必須入力

- 対象リポジトリ（Owner/Repo）
- GitHub Project 番号
- レポート種別（週報 / 日報 / マイルストーン / EV）
- 配信先（Issue コメント / Discussion / Wiki）

## ワークフロー

1. レポート種別に応じたデータ収集クエリを生成
2. レポートテンプレートを選択（`assets/weekly-report-template.md` を再利用）
3. データ集計・レポート生成 Actions ワークフローを生成
4. 定期実行スケジュール設定

## レポート種別

| レポート | 頻度 | 内容 | 配信先 |
|--------|------|------|--------|
| 週報 | 毎週月曜 09:00 JST | 完了タスク、進行中タスク、ブロッカー、来週の計画 | Discussion |
| 日報 | 毎日 18:00 JST | 当日完了タスク、翌日予定 | Issue コメント |
| EV レポート | 毎週金曜 17:00 JST | PV/EV/AC/SPI/CPI 推移 | Discussion |
| マイルストーン | マイルストーン期限の3日前 | 進捗率、残タスク、リスク | Assignee メンション |

## 週報テンプレート構成

```
## 📊 週報: {project_name} ({period})
### ✅ 今週の完了タスク ({done_count}件)
### 🔄 進行中のタスク ({in_progress_count}件)
### 🚧 ブロッカー ({blocked_count}件)
### 📅 来週の計画
### 📈 EV サマリ (SPI: {spi}, CPI: {cpi})
```

## 成果物

- `report-setup.md`: レポート設定の概要
- `.github/workflows/weekly-report.yml`: 週報自動生成ワークフロー
- `.github/workflows/daily-report.yml`: 日報自動生成ワークフロー
- 週報を生成する際に `assets/weekly-report-template.md` を再利用する
- 月次レポートを生成する際に `assets/monthly-report-template.md` を再利用する

## Quality Gates

- [ ] GraphQL クエリが必要なフィールドを全て取得している
- [ ] cron スケジュールが UTC で正しく設定されている（JST-9h）
- [ ] レポートに PII（個人情報）が含まれていない
- [ ] レポートの Markdown がレンダリングエラーなく表示される

## Gotchas

- `schedule` トリガーの cron はデフォルトブランチのワークフローのみ対象。feature ブランチにワークフローを追加してもスケジュール実行されない
- GraphQL でプロジェクトデータを取得する際、`items` の `first` パラメータ上限は100。大規模プロジェクトではカーソルベースのページネーションが必須
- Discussion への投稿は `GITHUB_TOKEN` のスコープで `discussions: write` が必要。リポジトリ設定で Discussions が有効でなければ 404 エラーになる
- 日報の `当日完了タスク` は UTC 日付境界で計算される。JST で正確に区切るにはタイムゾーン変換ロジックが必要
- 月次レポートのデータ集計期間は月初〜月末だが、マイルストーン期限が月中の場合にスナップショットのタイミングで数値が変動する。集計基準日を固定（月末最終営業日等）すること

## 検証ループ

1. レポートワークフローとテンプレートを生成
2. チェック:
   - cron 式が UTC で正しいか（JST 09:00 → UTC 00:00）
   - GraphQL クエリが全必要フィールドを含むか
   - テンプレートの変数が全て解決されるか
3. 不合格の場合:
   - cron 式のタイムゾーンを修正
   - 不足フィールドをクエリに追加
   - 未解決変数のマッピングを追加
4. 全ゲート合格後のみ成果物を出力
