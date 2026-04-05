# .prompt.md テンプレート

スキルスイート用と単体スキル用の2種類のテンプレートを提供する。
スキル生成時に適切なテンプレートを選択して `prompts/<skill-name>.prompt.md` として出力すること。

---

## テンプレート A: スキルスイート用

```markdown
---
description: '<一行の説明。起動条件を含める。>'
mode: 'agent'
tools: ['codebase', 'editFiles', 'terminal', 'fetch', 'changes']
---

# <スイート表示名>

あなたは <ドメイン> の専門家です。

## スキルスイート参照
以下のファイルを読み込んで指示に従ってください:

- **オーケストレーター**: `<suite-name>/AGENTS.md`
- **規約**: `<suite-name>/copilot-instructions.md`

## 主要タスク
ユーザーの指示に応じて以下を実行してください:

1. **<タスク1>** — <説明>
2. **<タスク2>** — <説明>
3. **<タスク3>** — <説明>

## 使い方の例
- 「<典型的なユーザー発話例1>」
- 「<典型的なユーザー発話例2>」
- 「<典型的なユーザー発話例3>」

{{{ input }}}
```

---

## テンプレート B: 単体スキル用

```markdown
---
description: '<一行の説明。起動条件を含める。>'
mode: 'agent'
tools: ['codebase', 'editFiles', 'terminal']
---

# <スキル表示名>

あなたは <役割説明> です。

## スキル参照
以下のスキルファイルを読み込んで指示に従ってください:

- **スキル定義**: `<suite-name>/skills/<skill-name>/SKILL.md`

## 実行フロー
1. <フェーズ1> — <説明>
2. <フェーズ2> — <説明>
3. <フェーズ3> — <説明>

## 使い方の例
- 「<典型的なユーザー発話例1>」
- 「<典型的なユーザー発話例2>」

{{{ input }}}
```

---

## テンプレート C: 読み取り専用エージェント用

```markdown
---
description: '<監査・レビュー目的の説明。起動条件を含める。>'
mode: 'agent'
tools: ['codebase']
---

# <エージェント表示名>

あなたは `<agent-name>` エージェントです。
**読み取り専用**で <目的> を行い、改善提案を出力してください。

## エージェント定義
`<suite-name>/agents/<agent-name>.md` を読み込んで指示に従ってください。

## 監査観点
- <観点1>
- <観点2>
- <観点3>

## 使い方の例
- 「<典型的なユーザー発話例1>」
- 「<典型的なユーザー発話例2>」

{{{ input }}}
```

---

## ツール選択ガイド

| ツール | 用途 |
|--------|------|
| `codebase` | コードベース検索・参照 |
| `editFiles` | ファイル作成・編集 |
| `terminal` | コマンド実行（ビルド・テスト） |
| `fetch` | Web/API 取得 |
| `changes` | 差分・変更確認 |
| `githubRepo` | GitHub Issue/PR/ラベル操作 |

## ファイル命名規則

- スイート全体: `<suite-name>.prompt.md`
- 単体スキル: `<skill-name>.prompt.md`
- エージェント: `<agent-name>.prompt.md`
- 保存先（リポジトリ管理）: `<suite-name>/assets/prompts/`
- 保存先（ユーザー共通）: `%APPDATA%\Code\User\prompts\`（Windows）
