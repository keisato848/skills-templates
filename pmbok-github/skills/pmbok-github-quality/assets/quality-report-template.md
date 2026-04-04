# 品質レポートテンプレート
#
# 品質レポートを生成する際にこのテンプレートを再利用する。
# 変数は {variable_name} 形式で埋め込み、Actions で置換する。

## 📋 品質レポート: {project_name}

**報告日**: {report_date}
**報告期間**: {period_start} 〜 {period_end}

---

### 品質スコアサマリ

| 指標 | 値 | ステータス |
|------|-----|----------|
| 品質スコア平均 | {avg_quality_score}/100 | {quality_status} |
| レビュー通過率 | {review_pass_rate}% | {review_status} |
| テストカバレッジ | {test_coverage}% | {coverage_status} |

### 欠陥統計

| 重要度 | オープン | 今期新規 | 今期クローズ | 累計 |
|--------|---------|---------|------------|------|
| Critical | {critical_open} | {critical_new} | {critical_closed} | {critical_total} |
| High | {high_open} | {high_new} | {high_closed} | {high_total} |
| Medium | {medium_open} | {medium_new} | {medium_closed} | {medium_total} |
| Low | {low_open} | {low_new} | {low_closed} | {low_total} |

### 欠陥メトリクス

| メトリクス | 値 |
|-----------|-----|
| 欠陥密度 | {defect_density} |
| 欠陥除去率 | {defect_removal_rate}% |
| 平均修正時間 | {avg_fix_time}h |
| 欠陥再発率 | {defect_recurrence_rate}% |

### レビュープロセス

| 項目 | 値 |
|------|-----|
| PR レビュー完了数 | {pr_reviewed} |
| PR 平均レビュー時間 | {avg_review_time}h |
| リジェクト数 | {pr_rejected} |
| リワーク率 | {rework_rate}% |

### 品質トレンド

{quality_trend_text}

### 改善提案

{improvement_suggestions}

---
*データソース最終更新: {data_last_updated}*
