# EV Report Template
#
# EV レポートを生成する際にこのテンプレートを再利用する。
# 変数は {variable_name} 形式で埋め込み、Actions で置換する。

## 📊 EV（アーンド・バリュー）レポート

**プロジェクト**: {project_name}
**報告日**: {report_date}
**報告期間**: {period_start} 〜 {period_end}

---

### サマリ

| 指標 | 値 | 評価 |
|------|-----|------|
| BAC (総予算) | {bac}h | — |
| PV (計画価値) | {pv}h | — |
| EV (出来高) | {ev}h | — |
| AC (実コスト) | {ac}h | — |
| SV (スケジュール差異) | {sv}h | {sv_status} |
| CV (コスト差異) | {cv}h | {cv_status} |
| SPI | {spi} | {spi_status} |
| CPI | {cpi} | {cpi_status} |

### 評価基準

| 指標 | 🟢 良好 | 🟡 注意 | 🔴 要対応 |
|------|--------|--------|----------|
| SPI | ≥ 1.0 | 0.8 - 1.0 | < 0.8 |
| CPI | ≥ 1.0 | 0.8 - 1.0 | < 0.8 |

### 進捗状況

- **完了タスク数**: {done_count} / {total_count} ({done_pct}%)
- **進行中タスク数**: {in_progress_count}
- **未着手タスク数**: {todo_count}

### 分析

{analysis_text}

### 推奨アクション

{recommendations}
