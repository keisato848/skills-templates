# 月次マネジメントレポートテンプレート
#
# 月次レポートを生成する際にこのテンプレートを再利用する。
# 変数は {variable_name} 形式で埋め込み、Actions で置換する。

## 📊 月次マネジメントレポート: {project_name}

**報告月**: {report_month}
**作成日**: {report_date}
**作成者**: GitHub Actions (自動生成)

---

### エグゼクティブサマリ

**全体ステータス**: {overall_status}

{executive_summary}

### 1. スケジュール

| 指標 | 今月 | 先月 | 変化 |
|------|------|------|------|
| SPI | {spi_current} | {spi_previous} | {spi_delta} |
| 完了 Issue | {done_current} | {done_previous} | {done_delta} |
| 遅延 Issue | {delayed_current} | {delayed_previous} | {delayed_delta} |

**マイルストーン達成状況**:

| マイルストーン | 期限 | 進捗率 | ステータス |
|--------------|------|--------|----------|
{milestone_table}

### 2. コスト

| 指標 | 値 | ステータス |
|------|-----|----------|
| CPI | {cpi} | {cpi_status} |
| SPI | {spi} | {spi_status} |
| EAC | {eac} | — |
| VAC | {vac} | {vac_status} |
| TCPI | {tcpi} | {tcpi_status} |

**CPI/SPI 推移グラフ**:
{cpi_spi_trend}

### 3. 品質

| 指標 | 今月 | 先月 | 変化 |
|------|------|------|------|
| 品質スコア平均 | {quality_current} | {quality_previous} | {quality_delta} |
| オープン欠陥 | {defects_current} | {defects_previous} | {defects_delta} |
| レビュー通過率 | {review_current}% | {review_previous}% | {review_delta} |

### 4. リスク

**Top 5 リスク**:

| ランク | リスク | スコア | 対応状況 |
|--------|--------|--------|----------|
{top_risks_table}

**リスク予備費消化状況**: {risk_reserve_status}

- 新規リスク: {new_risks_count}件
- クローズリスク: {closed_risks_count}件
- エスカレーション: {escalation_count}件

### 5. 変更要求サマリ

| CR# | 件名 | ステータス | 影響 |
|-----|------|----------|------|
{change_requests_table}

### 6. 来月の計画・重点事項

{next_month_plan}

### 7. 課題・エスカレーション

{issues_escalations}

---
*データソース最終更新: {data_last_updated}*
