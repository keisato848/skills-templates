---
name: pmbok-github-schedule
description: |
  GitHub Projects でスケジュール管理を実現する。ガントチャート設定、
  タスク依存関係、クリティカルパス自動判定、遅延時の後続タスク日程自動シフトを構築する。
  Use when スケジュール設定、ガントチャート表示、依存関係の定義、
  クリティカルパス判定、遅延アラート・自動シフトが必要な場合。
---

# PMBOK GitHub Schedule

GitHub Projects + Actions でスケジュール管理を構築する。

## このスキルを使用する場面

- Roadmap ビューでガントチャートを設定する
- タスク間の依存関係（FS/FF/SS/SF）を定義する
- クリティカルパスの自動判定ワークフローを構築する
- 遅延時に後続タスクの日程を自動シフトする Actions を生成する
- マイルストーンの設定と進捗監視

## 必須入力

- 対象リポジトリ（Owner/Repo）
- GitHub Project 番号（既存プロジェクトの場合）
- タスク一覧（Issue 番号 or タスク名リスト）

## ワークフロー

1. タスク一覧と依存関係を収集
2. Roadmap ビュー設定ガイドを生成
3. 依存関係定義（Tracks/Tracked by + カスタムフィールドの `dependency_type`）
4. クリティカルパス判定用 Actions ワークフローを生成（`assets/critical-path-action.yml` テンプレートを再利用）
5. 遅延自動シフト用 Actions ワークフローを生成（`assets/delay-shift-action.yml` テンプレートを再利用）
6. マイルストーン設定ガイドを生成

## 依存関係タイプ

| タイプ | 意味 | GitHub での実現方法 |
|--------|------|-------------------|
| FS (Finish-to-Start) | 先行完了→後続開始 | Tracks/Tracked by + ラベル |
| FF (Finish-to-Finish) | 先行完了→後続完了 | カスタムフィールドで管理 |
| SS (Start-to-Start) | 先行開始→後続開始 | カスタムフィールドで管理 |
| SF (Start-to-Finish) | 先行開始→後続完了 | カスタムフィールドで管理 |

## クリティカルパス判定ロジック

1. 全タスクの開始日・終了日・依存関係を取得（GraphQL API）
2. 前進パス計算: 最早開始日(ES)・最早終了日(EF) を算出
3. 後退パス計算: 最遅開始日(LS)・最遅終了日(LF) を算出
4. フロート = LS - ES（フロート0のタスクがクリティカルパス）
5. クリティカルパス上のタスクに `critical-path` ラベルを自動付与

## 遅延自動シフトロジック

1. Issue の `end_date` 変更を検知（Actions: `issues.edited` イベント）
2. 変更された Issue の後続タスク（Tracked by）を取得
3. 依存タイプに応じて後続タスクの `start_date` / `end_date` を再計算
4. 影響範囲をコメントで通知

## 成果物

- `schedule-report.md`: スケジュール設定の概要
- `.github/workflows/critical-path.yml`: クリティカルパス判定ワークフロー
- `.github/workflows/delay-shift.yml`: 遅延自動シフトワークフロー

## Quality Gates

- [ ] 全タスクに `start_date` と `end_date` が設定されている
- [ ] 依存関係にサイクル（循環参照）が存在しない
- [ ] クリティカルパス判定の Actions ワークフローが構文的に正しい
- [ ] 遅延シフトが連鎖的に伝播する（A→B→C の場合、Aの遅延がCまで反映）

## Gotchas

- GitHub の Tracks/Tracked by は依存タイプ（FS/FF等）を区別しない。タイプの区別には `dependency_type` カスタムフィールドを併用する
- Roadmap ビューの日付は `Date` 型カスタムフィールドまたは Iteration で制御する。Issue の `milestone.due_on` は Roadmap に反映されない
- Actions での GraphQL クエリは1回あたり100ノード上限。大規模プロジェクト（100タスク超）ではページネーション処理が必須
- `schedule` トリガーの cron は UTC 基準。JST 09:00 に実行したい場合は `cron: '0 0 * * *'` と指定する

## 検証ループ

1. 依存関係定義と Actions ワークフローを生成
2. チェック:
   - 依存関係グラフにサイクルがないか
   - 全日付フィールドが ISO 8601 形式か
   - Actions YAML の構文が正しいか
3. 不合格の場合:
   - サイクルを検出してユーザーに報告
   - 日付フォーマット違反を修正
   - YAML 構文エラーを修正
4. 全ゲート合格後のみ成果物を出力
