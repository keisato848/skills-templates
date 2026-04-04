---
name: pmbok-github
description: |
  GitHub上でPMBOK知識エリアに基づくプロジェクト管理を実現する。
  スケジュール・コスト・品質・リスク・リソース・ステークホルダー管理を
  GitHub Projects + Actions で構築・運用する場合に使用する。
---

# PMBOK GitHub Manager v0.1.0

PMBOK知識エリアに基づくGitHubプロジェクト管理。最も適切なサブスキルにルーティングし、全ての出力をファイルに保存する。

## 基本ルール

- 全ての成果物をファイルに保存する。チャットにのみ結果を残さない
- `report.md` はユーザーの入力と同じ言語で記述する
- GitHub API の直接操作よりも、再利用可能な Actions ワークフローの生成を優先する
- カスタムフィールド名は英語スネークケース（例: `planned_hours`）、表示名は日本語可

## ルーティングルール

### WHEN/DO ディスパッチ

WHEN: GitHub Project の新規セットアップ、カスタムフィールド定義、ラベル体系構築、Issue テンプレート作成
DO: → `pmbok-github-init`

WHEN: スケジュール設定、ガントチャート、依存関係、クリティカルパス、遅延シフト、マイルストーン
DO: → `pmbok-github-schedule`

WHEN: コスト管理、EV算出、予定工数、実績工数、工数集計
DO: → `pmbok-github-cost`

WHEN: 品質管理、CI/CD連携、テスト結果、バグトラッキング、自動差し戻し
DO: → `pmbok-github-quality`

WHEN: リスク管理、リスク登録簿、発生確率、影響度、リスクアラート
DO: → `pmbok-github-risk`

WHEN: レポート生成、週報、日報、進捗報告、ステークホルダー向け報告
DO: → `pmbok-github-report`

### タスク分類

1. プロジェクトの初期構築か？
   - YES → `pmbok-github-init`
   - NO → 次へ
2. スケジュール・日程に関することか？
   - YES → `pmbok-github-schedule`
   - NO → 次へ
3. 工数・コストに関することか？
   - YES → `pmbok-github-cost`
   - NO → 次へ
4. テスト・品質・CI/CDに関することか？
   - YES → `pmbok-github-quality`
   - NO → 次へ
5. リスクに関することか？
   - YES → `pmbok-github-risk`
   - NO → 次へ
6. レポート・報告に関することか？
   - YES → `pmbok-github-report`
   - NO → 直接回答

### フルワークフロー（新規プロジェクト構築時）

Phase 0 → `pmbok-github-init`: GitHub Project 初期セットアップ ⏸️ ユーザー承認
Phase 1 → `pmbok-github-schedule`: スケジュール管理の設定
Phase 2 → `pmbok-github-cost`: コスト管理の設定
Phase 3 → `pmbok-github-quality`: 品質管理の設定
Phase 4 → `pmbok-github-risk`: リスク管理の設定 ⏸️ ユーザー承認
Phase 5 → `pmbok-github-report`: レポート自動生成の設定

### 緊急度トリアージ

| 緊急度 | キーワード | ワークフロー |
|--------|-----------|------------|
| 通常 | （デフォルト） | フル実行（全Phase） |
| 急ぎ | 「急ぎ」「ASAP」 | 該当スキルのみ実行 |
| 至急 | 「至急」「今すぐ」 | 設定ファイル生成のみ |

## マルチエージェント構成

### Agent → Harness 軸マッピング

| エージェント | 役割 | ツール | Harness 軸 | 権限 |
|-------------|------|---------|------------|------|
| `pm-orchestrator` | 全体統括・Phase管理・スキル間連携 | 全ツール | Tool Coverage | 読み書き |
| `pm-auditor` | プロジェクト設定の整合性監査 | read_file, grep_search, list_directory | Quality Gates | 読み取り専用 |
| `pm-learner` | Gotchas収集・知見蓄積 | read_file, grep_search, list_directory | Memory Persistence | 読み取り専用 |
| `pm-security` | セキュリティ監査・PII検出 | read_file, grep_search, list_directory | Security Guardrails | 読み取り専用 |
| `pm-validator` | 出力検証・整合性チェック | read_file, grep_search, list_directory, run_in_terminal | Eval Coverage | 読み取り + 検証コマンド |

### エージェント間委譲ルール

サブエージェントからサブエージェントへの直接委譲を許可する。

```
pm-orchestrator（全体統括）
├─→ 全スキルへのルーティング
├─→ 全エージェントへの委譲
│
pm-auditor（設定監査）
├─→ pm-orchestrator: 不整合の修正依頼
├─→ pm-security: セキュリティ違反の確認依頼
│
pm-learner（知見収集）
├─→ pm-orchestrator: Gotchas のファイル追記依頼
├─→ pm-security: セキュリティ知見の分類依頼
├─→ pm-validator: 検証ルール改善の提案
│
pm-security（セキュリティ監査）
├─→ pm-orchestrator: 違反の修正依頼
├─→ pm-learner: セキュリティ知見の記録依頼
├─→ pm-validator: セキュリティ検証ルールの追加依頼
│
pm-validator（出力検証）
├─→ pm-orchestrator: 検証失敗の修正依頼
├─→ pm-security: セキュリティ違反の報告
├─→ pm-learner: 検証で得た知見の記録依頼
```

### 委譲の原則

1. **ファイル変更は pm-orchestrator 経由のみ** — 他の4体は読み取り専用
2. **循環委譲の禁止** — A→B→A のような委譲ループは最初の委譲元で打ち切る
3. **委譲チェーンは最大3ホップ** — A→B→C→（ここで完了）
4. **委譲時はコンテキストを明示** — 何を、なぜ、どのように委譲するか

## MCP 連携

- MCP サーバー: `github`（`.mcp.json` 参照）
- 同時有効化上限: 10サーバー以下（現在 1/10）
- MCP 利用優先順位: MCP → `gh` CLI → REST API curl
- MCP 利用不可時は `gh` CLI コマンドをフォールバックとして提示

## 検証ループ

計画 → 実行 → 検証（pm-validator）→ 報告 → 記録（pm-learner）

## Quality Gates

- [ ] 全カスタムフィールドが GitHub Projects V2 の型制約に準拠している
- [ ] GitHub Actions ワークフローが構文的に正しい（`actionlint` 通過 — pm-validator で検証）
- [ ] 生成した Issue テンプレートが `.github/ISSUE_TEMPLATE/` の規約に従っている
- [ ] 対象外の機能を実装していない（README.md の対象外リストを参照）
- [ ] セキュリティ監査を通過している（pm-security で検証）

## 禁止事項

- GitHub API トークンをファイルにハードコードしない（`${{ secrets.GITHUB_TOKEN }}` を使用）
- 個人の人件費単価や給与情報を Issue/Project に記載しない
- `--force` 系のオプションを使った破壊的操作を自動化しない
- 外部 SaaS との連携時に認証情報を平文で保存しない
- 読み取り専用エージェント（pm-auditor, pm-learner, pm-security）がファイルを変更しない

## Gotchas

- GitHub Projects V2 のカスタムフィールドは API 経由でのみ一括作成できる。UI からは1つずつ手動作成が必要
- Roadmap ビューの依存関係線は GitHub Projects V2 の「Tracks/Tracked by」で実現するが、Issue 間の依存関係（Blocks/Blocked by）は別概念
- GitHub Actions の `schedule` トリガーは UTC 基準。JSTで指定する場合は -9 時間のオフセットが必要
- Projects V2 の GraphQL API はスキーマが頻繁に変わる。公式ドキュメントのバージョン日付を必ず確認する
- エージェント間委譲でコンテキストが失われやすい。委譲時は必ず「対象ファイル + 問題内容 + 期待する成果」の3点を明示すること
