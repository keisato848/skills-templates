---
name: pmbok-github-cost
description: |
  GitHub Projects でコスト・EV（アーンド・バリュー）管理を実現する。
  予定工数・実績工数のカスタムフィールド設計、EV算出ワークフロー、工数集計レポートを生成する。
  Use when コスト管理、EV算出、予定工数と実績工数の入力・集計、
  工数レポートの自動生成が必要な場合。
---

# PMBOK GitHub Cost

GitHub Projects + Actions でコスト・EV管理を構築する。

## このスキルを使用する場面

- 予定工数と実績工数のカスタムフィールドを設計する
- EV（アーンド・バリュー）を算出する仕組みを構築する
- 工数集計レポートを自動生成する
- PV/EV/AC の推移を追跡する

## 必須入力

- 対象リポジトリ（Owner/Repo）
- GitHub Project 番号
- 報告頻度（デフォルト: 週次）

## ワークフロー

1. コスト管理用カスタムフィールドの設計（`planned_hours`, `actual_hours` 等）
2. EV 算出ロジックの定義
3. 工数集計 Actions ワークフローを生成
4. EV レポートテンプレートを生成（`assets/ev-report-template.md` を再利用）
5. Issue コメントでの工数入力ガイドを作成

## EV 算出定義

| 指標 | 計算式 | GitHub上の取得方法 |
|------|--------|-------------------|
| BAC (Budget at Completion) | Σ 全タスクの `planned_hours` | GraphQL: Project items の `planned_hours` 合計 |
| PV (Planned Value) | 報告日までの計画工数累計 | `end_date` ≤ 報告日のタスクの `planned_hours` 合計 |
| EV (Earned Value) | 完了タスクの `planned_hours` 累計 | Status=Done のタスクの `planned_hours` 合計 |
| AC (Actual Cost) | 完了タスクの `actual_hours` 累計 | Status=Done のタスクの `actual_hours` 合計 |
| SPI (Schedule Performance Index) | EV / PV | 算出値 |
| CPI (Cost Performance Index) | EV / AC | 算出値 |
| SV (Schedule Variance) | EV - PV | 算出値 |
| CV (Cost Variance) | EV - AC | 算出値 |

## 工数入力ルール

- Issue コメントに `⏱️ 2.5h` 形式で実績を入力
- Actions が正規表現 `⏱️\s*(\d+\.?\d*)h` でパースし `actual_hours` に加算
- 1 Issue あたり複数回の工数入力に対応（累積加算）

## 成果物

- `cost-report.md`: コスト管理設定の概要
- `.github/workflows/ev-calc.yml`: EV算出・レポート生成ワークフロー
- `.github/workflows/time-track.yml`: 工数入力パース・集計ワークフロー
- EV レポートを生成する際に `assets/ev-report-template.md` を再利用する

## Quality Gates

- [ ] EV 算出に必要なカスタムフィールド（`planned_hours`, `actual_hours`）が定義済み
- [ ] 工数入力の正規表現が誤入力をリジェクトできる
- [ ] PV=0 の場合の SPI 算出でゼロ除算が発生しない（ガード処理あり）
- [ ] レポートが Markdown テーブル形式で生成される

## Gotchas

- `Number` 型カスタムフィールドは小数点以下が扱えるが、GUI 上の表示桁数は制御できない。レポート出力時に `%.1f` でフォーマットする
- EV の算出は「完了タスクの計画工数」であり「実績工数」ではない。この混同は SPI/CPI を無意味にする
- 工数入力のコメントパースは Actions の `issue_comment.created` イベントで行う。コメント編集（`edited`）も拾う場合は二重加算に注意
- GitHub Projects V2 の Number 型フィールドには上限値の設定がない。バリデーションは Actions 側で実装する（例: 1日24h超の入力をリジェクト）

## 検証ループ

1. EV算出ワークフローと工数集計ワークフローを生成
2. チェック:
   - EV 計算式が PMBOK 定義と一致しているか
   - ゼロ除算ガードが全指標に含まれているか
   - Actions YAML の構文が正しいか
3. 不合格の場合:
   - 計算式の誤りを修正
   - ガード処理を追加
   - YAML 構文エラーを修正
4. 全ゲート合格後のみ成果物を出力
