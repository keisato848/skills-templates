# GitHub Projects V2 カスタムフィールド仕様

pmbok-github-init のカスタムフィールド設計で、フィールド数が多い場合やフィールド間の依存関係を確認する場合にこのリファレンスを読む。

## フィールド型仕様

| 型 | 用途 | 制約 |
|----|------|------|
| Text | 自由入力テキスト | 1024文字上限 |
| Number | 数値（整数・小数） | 小数点以下対応、上限値なし |
| Date | 日付（YYYY-MM-DD） | タイムゾーン情報なし |
| Single Select | 単一選択 | オプション数に実質上限なし、後から追加可能 |
| Iteration | スプリント/イテレーション | 期間指定（週単位）、過去・未来の制限なし |

## フィールド作成 GraphQL ミューテーション

```graphql
mutation CreateProjectField($projectId: ID!, $name: String!, $dataType: ProjectV2CustomFieldType!) {
  createProjectV2Field(input: {
    projectId: $projectId
    dataType: $dataType
    name: $name
  }) {
    projectV2Field {
      ... on ProjectV2Field {
        id
        name
      }
      ... on ProjectV2SingleSelectField {
        id
        name
        options {
          id
          name
        }
      }
    }
  }
}
```

## Single Select フィールドのオプション作成

```graphql
mutation CreateSelectOption($projectId: ID!, $fieldId: ID!, $name: String!) {
  createProjectV2FieldOption(input: {
    projectId: $projectId
    fieldId: $fieldId
    name: $name
  }) {
    projectV2SingleSelectField {
      options {
        id
        name
      }
    }
  }
}
```

## フィールド間依存関係

```
planned_hours ──┐
                ├→ EV算出（pmbok-github-cost）
actual_hours  ──┘

risk_probability ──┐
                   ├→ priority_score 自動算出（pmbok-github-risk）
risk_impact      ──┘

start_date ──┐
             ├→ クリティカルパス判定（pmbok-github-schedule）
end_date   ──┘
dependency_type ──┘

wbs_code → WBS階層表示（Grouping）
```

## 推奨ビュー構成

| ビュー名 | タイプ | グループ化 | フィルター | ソート |
|---------|--------|----------|----------|--------|
| Board | Board | Status | なし | Priority |
| Roadmap | Roadmap | なし | has:start_date | start_date ASC |
| Cost | Table | なし | has:planned_hours | wbs_code ASC |
| Risk | Table | risk_probability | type:risk ラベル | priority_score DESC |
| WBS | Table | wbs_code | なし | wbs_code ASC |
