---
name: pmbok-github-quality
description: |
  GitHub でプロジェクト品質管理を実現する。CI/CDテスト結果に基づくIssueの自動差し戻し、
  バグトラッキングラベル体系、コードレビュー状況の可視化を構築する。
  Use when 品質管理、CI/CDテスト連携、テスト結果に基づく自動差し戻し、
  バグトラッキング体系の構築が必要な場合。
---

# PMBOK GitHub Quality

GitHub Actions + Labels で品質管理を構築する。

## このスキルを使用する場面

- CI/CD テスト結果に基づく Issue 自動差し戻しを設定する
- バグトラッキング用のラベル体系を構築する
- コードレビュー状況の可視化ルールを定義する
- PR マージ条件に品質ゲートを追加する

## 必須入力

- 対象リポジトリ（Owner/Repo）
- CI/CD ツール（GitHub Actions / 外部 CI）
- テストフレームワーク名（任意）

## ワークフロー

1. 品質管理用ラベル体系を設計（`bug:severity-*`, `qa:*`）
2. CI/CD テスト結果→Issue ステータス連動の Actions を生成
3. PR マージ条件（Branch Protection Rules）のガイドを生成
4. バグ分類用 Issue テンプレートを生成

## CI/CD → Issue 自動差し戻しロジック

1. PR に紐づく Issue 番号を取得（`Closes #123` パターン）
2. CI テストが失敗した場合:
   - Issue のステータスを「In Progress」に差し戻し
   - `qa:test-failed` ラベルを付与
   - Issue にテスト失敗サマリをコメント（失敗テスト名 + エラー概要）
3. CI テストが成功した場合:
   - `qa:test-failed` ラベルを除去
   - `qa:test-passed` ラベルを付与

## バグ重要度ラベル

| ラベル | 意味 | 対応期限目安 |
|--------|------|------------|
| `bug:severity-critical` | サービス停止 | 即時対応 |
| `bug:severity-high` | 主要機能障害 | 24時間以内 |
| `bug:severity-medium` | 機能制限あり | 次スプリント |
| `bug:severity-low` | 軽微な不具合 | バックログ |

## 成果物

- `quality-report.md`: 品質管理設定の概要
- `.github/workflows/qa-gate.yml`: CI/CD→Issue 連動ワークフロー
- `.github/ISSUE_TEMPLATE/bug-report.yml`: バグ報告テンプレート
- 品質レポートを生成する際に `assets/quality-report-template.md` を再利用する

## Quality Gates

- [ ] CI/CD ワークフローが PR 内の Issue 番号を正しくパースできる
- [ ] テスト失敗時のステータス差し戻しが冪等（複数回実行しても同じ結果）
- [ ] バグ重要度ラベルが重複なく定義されている
- [ ] Branch Protection Rules のガイドが正しい設定値を示している

## Gotchas

- `Closes #123` のパターンは PR 本文だけでなくコミットメッセージからも検出される。意図しないクローズを防ぐにはコミットメッセージ規約を定めること
- GitHub Actions の `check_suite` イベントと `workflow_run` イベントは挙動が異なる。PR のテスト結果取得には `pull_request` + `status` の組み合わせが確実
- ステータス差し戻し時に Assignee への通知が飛ぶのは GitHub のデフォルト動作。過剰な通知を避けるにはフィルタリングが必要
- Branch Protection Rules は Organization の Free プランでは public リポジトリでのみ利用可能
- 品質スコアの途中変更は過去データとの比較を無意味にする。スコアリングルブリックを変更する場合は過去データの再評価方針を事前に決定すること

## 検証ループ

1. QA ゲートワークフローとバグテンプレートを生成
2. チェック:
   - Issue 番号パース正規表現が正しいか
   - ステータス遷移が冪等か
   - Actions YAML の構文が正しいか
3. 不合格の場合:
   - 正規表現を修正
   - 冪等性チェックロジックを追加
   - YAML 構文エラーを修正
4. 全ゲート合格後のみ成果物を出力
