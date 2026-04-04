# skills-templates

Harness 最適化された Agent Skills 開発テンプレートリポジトリです。  
このリポジトリをテンプレートとして使用し、独自の Agent Skills スイートを効率的に構築できます。

## 概要

本リポジトリは **Coreclaw Marketplace** の Agent Skills 開発基盤を提供します。  
スキルの設計・生成・監査・最適化を支援する開発用メタスキル群と、Custom Agent が含まれています。

## リポジトリ構成

```
.github/
├── copilot-instructions.md    # プロジェクト全体の規約・開発ルール
├── agents/                    # Custom Agents（カスタムエージェント）
│   ├── harness-reviewer.md    # 読み取り専用の品質レビューエージェント
│   └── skill-developer.md     # フルライフサイクルのスキル開発エージェント
└── skills/                    # 開発支援スキル群
    ├── description-optimizer/ # description フィールド最適化
    ├── gotchas-curator/       # 学び・落とし穴の収集・管理
    ├── harness-auditor/       # Harness 7軸フレームワーク監査
    ├── orchestrator-designer/ # AGENTS.md オーケストレーター設計
    ├── purpose-discovery/     # 要件の構造化ヒアリング
    └── skill-scaffolder/      # スキルパッケージ生成（テンプレート付き）
```

## 含まれるスキル

| スキル名 | 説明 |
|---------|------|
| **description-optimizer** | スキルの `description` フィールドを最適化し、ルーティング精度と発見精度を最大化する |
| **gotchas-curator** | タスク完了時やミス発生時の学びを収集し、Gotchas セクションに反映する |
| **harness-auditor** | Harness 7軸フレームワークでスキルと周辺環境を監査・スコアリングする |
| **orchestrator-designer** | WHEN/DO ルーティング、Phase 設計、タスク分類ツリーを含む AGENTS.md を設計する |
| **purpose-discovery** | 1問1答の構造化ダイアログでスキル開発の要件を明確化する |
| **skill-scaffolder** | Harness 最適化されたスキルパッケージをフルスイートで生成する |

## Custom Agents

| エージェント名 | 役割 | ツール権限 |
|-------------|------|----------|
| **harness-reviewer** | 読み取り専用の Harness 品質レビュー | 読み取り・検索のみ |
| **skill-developer** | スキルの設計・生成・検証・最適化 | 全ツールアクセス |

## 使い方

### テンプレートからリポジトリを作成

1. GitHub で「**Use this template**」ボタンをクリック
2. 新しいリポジトリ名を入力して作成
3. ローカルにクローン

### スキル開発の開始

```bash
# リポジトリをクローン
git clone <your-repo-url>
cd <your-repo-name>

# 依存関係をインストール
npm install
```

VS Code で開き、Copilot Chat から `skill-developer` エージェントを呼び出すことで、対話的にスキルを開発できます。

### スキルスイートの構成

新しいスキルスイートはプロジェクトルート直下に配置します:

```
<agent-skills-name>/
├── AGENTS.md              # オーケストレーター（WHEN/DO ルーティング）
├── copilot-instructions.md # スイート固有の規約
├── README.md              # スイート説明
├── group.json             # グループメタデータ
├── skill.json             # パッケージメタデータ
├── .mcp.json              # MCP サーバー設定（必要な場合）
├── agents/                # Custom Agents
│   └── <agent-name>.md
└── skills/                # サブスキル
    └── <skill-name>/
        ├── SKILL.md       # 必須: メタデータ + 指示内容
        ├── scripts/       # 任意: 実行可能なコード
        ├── references/    # 任意: 参照ドキュメント
        └── assets/        # 任意: テンプレート、リソース
```

## Harness 7軸フレームワーク

すべてのスキルは以下の 7軸で品質を評価されます:

| # | 軸 | 評価内容 |
|---|-----|---------|
| 1 | Tool Coverage | description の品質、キーワード棲み分け、WHEN/DO ルーティング |
| 2 | Context Efficiency | SKILL.md の行数、条件付き参照、assets/references の活用 |
| 3 | Quality Gates | 検証ループ、失敗時リカバリ、チェックリスト |
| 4 | Memory Persistence | Gotchas の具体性、学びの収集、コンパクション耐性 |
| 5 | Eval Coverage | バリデーションループ、CI 統合ポイント |
| 6 | Security Guardrails | 禁止事項、データ取り扱い、読み取り専用エージェント |
| 7 | Cost Efficiency | MCP 上限、デフォルト明示、簡潔な設計 |

スコアリング: 各軸 0〜3 点、合計 21 点満点  
成熟度: Beginner (0–7) / Intermediate (8–14) / Advanced (15–18) / Expert (19–21)

## ライセンス

ISC
