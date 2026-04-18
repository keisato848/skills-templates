---
name: dotnet-test-generator
description: >
  C# ソースファイルを解析し、xUnit ベースのユニットテストコードを
  Arrange-Act-Assert パターンで一括生成する。
  Use when: 新規テストを作成したい、テストが未実装のクラスにテストを追加したい、
  public メソッド全体のカバレッジ土台を一括生成したい、dotnet test を通るテストが必要。
---

# .NET Unit Test Generator

C# クラスを解析し、xUnit ユニットテストコードを自動生成する。

## このスキルを使用する場面

- 既存 C# クラスにテストが存在しない・少ない
- `dotnet test` を通るテストコードを素早く作成したい
- public メソッド全体のカバレッジ土台を一括で生成したい

## ワークフロー

### Phase 1: 解析

1. `list_dir` でプロジェクト構造を把握する
2. `read_file` でテスト対象 `.cs` ファイルを読み取る
3. `grep_search` で `public` メソッド・クラス・コンストラクタ・プロパティを抽出する
4. 依存オブジェクト（コンストラクタ引数の型）を特定する
5. インターフェース引数がある場合 → Moq 使用フラグを立てる

### Phase 2: 生成

**命名規則**:
| 要素 | 規則 |
|------|------|
| テストクラス名 | `{TargetClassName}Tests` |
| 名前空間 | テスト対象と同一 + `.Tests` |
| テストメソッド名 | `{MethodName}_{Condition}_{ExpectedResult}` |

**属性の使い分け**:
- 単一入力 → `[Fact]`
- 複数入力バリエーション → `[Theory]` + `[InlineData(...)]`
- 非同期メソッド → `public async Task {Name}()` に `[Fact]` / `[Theory]`

**ケース網羅**:
- 正常ケース（典型的な入力・期待出力）
- エッジケース（null, 空文字, 0, 境界値）
- 異常ケース（`Assert.Throws<T>` / `await Assert.ThrowsAsync<T>`）

**各テストメソッドのフォーマット**:
```csharp
[Fact]
public void MethodName_Condition_ExpectedResult()
{
    // Arrange
    ...
    // Act
    ...
    // Assert
    ...
}
```

**テンプレート使用**: テストクラスの雛形を生成する際は
`assets/xunit-test-template.md` のテンプレートを参照する。

### Phase 3: 提示 ⏸️

生成コードをコードブロックで提示しユーザー確認を求める。

出力フォーマット:
```
## 生成完了: {ClassName}Tests.cs
テストメソッド数: {count}（正常: {n} / エッジ: {n} / 異常: {n}）
対象ファイル: {TargetFile}

```csharp
{generated_code}
```

**次のステップ**:
- テストプロジェクト `{TestProjectName}/` に配置して `dotnet test` を実行
- Moq を使っている場合は `dotnet add package Moq` が必要
```

## 成果物

- `{ClassName}Tests.cs` のコードブロック（ファイルシステムへの書き込みは行わない）
- テストメソッド一覧と件数サマリー

## Quality Gates

- [ ] テストクラス名が `{TargetClassName}Tests` の命名規則に従っている
- [ ] すべてのテストメソッドに `[Fact]` または `[Theory]` 属性がある
- [ ] すべてのテストが AAA パターン（`// Arrange` / `// Act` / `// Assert` コメント付き）
- [ ] `using Xunit;` が using 文に含まれている
- [ ] 非同期メソッドのテストが `Task` 戻り値型になっている（`void` でない）
- [ ] 生成コードにコンパイルエラーとなる構文がない

いずれかが不合格の場合: 生成コードを修正してから提示する。

## Gotchas

- `static` クラス・メソッドはインスタンス化不要。`new` せず直接呼び出す
- 非同期メソッド（`async Task`）のテストを `void` テストにしてはならない。
  `async Task` で宣言し `await` して検証すること
- コンストラクタにインターフェース引数がある場合は Moq の `Mock<T>` が必要。
  忘れると `new ClassName()` でコンパイルエラーになる
- `null` 入力の例外テストは `Assert.Throws<ArgumentNullException>(() => ...)` を使う。
  `Assert.IsNull` と混同しないこと
- テスト対象クラスが `internal` の場合は `[assembly: InternalsVisibleTo("TestProject")]`
  が対象プロジェクトの `AssemblyInfo.cs` に必要。警告として出力に添付すること
- `[Theory]` + `[InlineData]` を使う場合、メソッドシグネチャの引数名と
  `[InlineData]` の順序・型を必ず一致させる

## 検証ループ

1. 生成コードを確認する
2. チェック: すべての `public` メソッドにテストが対応しているか
3. チェック: `using` 文が正しく揃っているか（Xunit, Moq, 対象名前空間）
4. 不足 → 不足メソッド分のテストを追記して再提示する
5. **失敗時リカバリ**:
   - 型名が不明 → `read_file` で対象ファイルを再度読み取り、クラス定義を確認する
   - 依存関係が複雑 → `Mock<T>.Object` で代替し、TODO コメントを添付する
   - テストプロジェクトが存在しない → 作成コマンド例を提示する:
     ```bash
     dotnet new xunit -n {ProjectName}.Tests
     dotnet sln add {ProjectName}.Tests
     dotnet add {ProjectName}.Tests reference {ProjectName}
     ```

## Security Guardrails

- テスト対象ソースに含まれる API キー・パスワード・接続文字列を
  テストコード内にそのまま使ってはならない
- 機密情報が必要な場合はプレースホルダ（例: `"YOUR_API_KEY_HERE"`）に
  差し替えて生成し、コメントで旨を明示する
