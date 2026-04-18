# dotnet-test-generator

C# ソースファイルを解析し、**xUnit ベースのユニットテスト**コードを Arrange-Act-Assert パターンで一括生成する Agent Skill。

## 概要

このスキルは、テスト対象の `.cs` ファイルを読み取り、public クラス・メソッドを解析して、`dotnet test` で即実行可能な xUnit テストコードを生成します。

## 主な機能

- public メソッド・クラス・コンストラクタの自動解析
- `[Fact]` / `[Theory]` 属性の適切な振り分け
- AAA（Arrange-Act-Assert）パターンの徹底
- 正常・エッジ・異常ケースの網羅的生成
- Moq 依存が必要な場合の自動判定

## 使い方

VS Code の Copilot Chat で:

```
@agent このクラスのユニットテストを生成して: src/Services/UserService.cs
```

または:

```
@agent テストを一括生成して: Controls/ 配下のすべての C# ファイル
```

## スキル構成

```
dotnet-test-generator/
└── skills/
    └── dotnet-test-generator/
        ├── SKILL.md                     # スキル定義
        └── assets/
            └── xunit-test-template.md  # テストクラステンプレート
```

## 対象環境

- .NET 6 以降（MAUI, ASP.NET Core, コンソールアプリ等すべて対応）
- xUnit 2.x 以降
- VS Code + GitHub Copilot Chat
