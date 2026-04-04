---
name: pmbok-github-init
description: |
  GitHub Project V2 の初期セットアップを実行する。カスタムフィールド定義、
  ラベル体系、ビュー設定、Issue テンプレートを一括生成する。
  Use when 新規プロジェクトの立ち上げ、GitHub Project の初期構築、
  カスタムフィールドやラベルの設計が必要な場合。
---

# PMBOK GitHub Init

GitHub Project V2 を PMBOK 対応でセットアップする。

## このスキルを使用する場面

- 新規プロジェクトで GitHub Project を構築する
- PMBOK 対応のカスタムフィールド・ラベル体系を設計する
- Issue テンプレートを一括生成する

## 必須入力

- プロジェクト名
- 対象リポジトリ（Owner/Repo）
- 管理対象の PMBOK 知識エリア（デフォルト: 全エリア）

## ワークフロー

1. ユーザーからプロジェクト情報を収集
2. カスタムフィールド定義を生成（フィールド名が100行超の場合 `references/custom-fields-spec.md` を参照）
3. ラベル体系定義を生成
4. GitHub Projects V2 のビュー設定を生成:
   - Board ビュー（ステータス別）
   - Roadmap ビュー（タイムライン）
   - Table ビュー（全フィールド一覧）
5. Issue テンプレートを `.github/ISSUE_TEMPLATE/` に生成
6. セットアップ用の GraphQL ミューテーションスクリプトを生成

## 成果物

- `setup-report.md`: セットアップ内容の概要
- `.github/ISSUE_TEMPLATE/`: Issue テンプレート群
- `scripts/setup-project.sh`: カスタムフィールド一括作成スクリプト

## カスタムフィールド定義（コア）

| フィールド名 | 表示名 | 型 | 用途 | 知識エリア |
|-------------|--------|-----|------|-----------|
| `planned_hours` | 予定工数(h) | Number | 計画工数 | コスト |
| `actual_hours` | 実績工数(h) | Number | 実績工数 | コスト |
| `risk_probability` | 発生確率 | Single Select (高/中/低) | リスク評価 | リスク |
| `risk_impact` | 影響度 | Single Select (高/中/低) | リスク評価 | リスク |
| `priority_score` | 優先度スコア | Number | リスク値(確率×影響度) | リスク |
| `start_date` | 開始日 | Date | スケジュール | スケジュール |
| `end_date` | 終了日 | Date | スケジュール | スケジュール |
| `dependency_type` | 依存タイプ | Single Select (FS/FF/SS/SF) | タスク依存 | スケジュール |
| `wbs_code` | WBSコード | Text | 階層管理 | スコープ |

## ラベル体系

| プレフィックス | 用途 | 例 |
|---------------|------|-----|
| `pmbok:` | 知識エリア分類 | `pmbok:schedule`, `pmbok:cost` |
| `priority:` | 優先度 | `priority:high`, `priority:medium` |
| `type:` | Issue 種別 | `type:task`, `type:risk`, `type:bug` |
| `phase:` | Phase 管理 | `phase:planning`, `phase:executing` |

## Quality Gates

- [ ] 全カスタムフィールドが GitHub Projects V2 でサポートされる型を使用している
- [ ] ラベル名に空白や特殊文字が含まれていない
- [ ] Issue テンプレートが YAML フロントマター形式に準拠している
- [ ] セットアップスクリプトが `GITHUB_TOKEN` 環境変数を参照している（ハードコードなし）

## Gotchas

- カスタムフィールドの型は作成後に変更不可。`Number` と `Text` の選択は慎重に行う
- GitHub Projects V2 は1プロジェクトあたりカスタムフィールド上限が存在する（2024年時点で約50個）。必要最小限に絞ること
- `Single Select` 型のオプション値は後から追加可能だが、既存の値の名前変更は既存 Issue に反映されない
- Organization レベルの Project は作成時に `org` スコープの権限が必要。リポジトリレベルなら `repo` スコープで十分

## 検証ループ

1. カスタムフィールド定義とラベル体系を生成
2. チェック:
   - フィールド名が英語スネークケースか
   - ラベルプレフィックスが一貫しているか
   - Issue テンプレートの YAML が valid か
3. 不合格の場合:
   - 命名規則違反をリスト化
   - 修正を適用
   - 再検証
4. 全ゲート合格後のみ成果物を出力
