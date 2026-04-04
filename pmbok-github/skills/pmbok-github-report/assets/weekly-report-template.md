# Weekly Report Template
#
# 週報を生成する際にこのテンプレートを再利用する。
# 変数は {variable_name} 形式で埋め込み、Actions で置換する。

## 📊 週報: {project_name}

**報告期間**: {period_start} 〜 {period_end}
**報告日**: {report_date}
**報告者**: GitHub Actions (自動生成)

---

### ✅ 今週の完了タスク ({done_count}件)

{done_tasks_table}

### 🔄 進行中のタスク ({in_progress_count}件)

{in_progress_tasks_table}

### 🚧 ブロッカー ({blocked_count}件)

{blocked_tasks_table}

### 📅 来週の計画

{next_week_tasks_table}

### 📈 プロジェクトサマリ

| 指標 | 値 |
|------|-----|
| 全タスク数 | {total_count} |
| 完了率 | {done_pct}% |
| SPI | {spi} |
| CPI | {cpi} |

### 🚨 高リスク項目

{high_risk_items}

### 📝 備考

{notes}
