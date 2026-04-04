# xUnit テストクラステンプレート

このテンプレートを `dotnet-test-generator` スキルで使用する。
テスト対象クラスに応じてプレースホルダを置き換えること。

## 基本テストクラス（依存なし）

```csharp
using Xunit;
using {TargetNamespace};

namespace {TargetNamespace}.Tests;

public class {ClassName}Tests
{
    private readonly {ClassName} _sut;

    public {ClassName}Tests()
    {
        _sut = new {ClassName}();
    }

    [Fact]
    public void {MethodName}_WhenValid_ReturnsExpected()
    {
        // Arrange
        {ArrangeCode}

        // Act
        var result = _sut.{MethodName}({Parameters});

        // Assert
        Assert.Equal({Expected}, result);
    }

    [Fact]
    public void {MethodName}_WhenNull_ThrowsArgumentNullException()
    {
        // Arrange
        {NullArrangeCode}

        // Act & Assert
        Assert.Throws<ArgumentNullException>(() => _sut.{MethodName}(null));
    }

    [Theory]
    [InlineData({Value1}, {Expected1})]
    [InlineData({Value2}, {Expected2})]
    public void {MethodName}_WithVariousInputs_ReturnsExpected({ParamType} input, {ReturnType} expected)
    {
        // Arrange
        // (値は InlineData から渡される)

        // Act
        var result = _sut.{MethodName}(input);

        // Assert
        Assert.Equal(expected, result);
    }
}
```

## Moq 使用テストクラス（インターフェース依存あり）

```csharp
using Moq;
using Xunit;
using {TargetNamespace};
using {InterfaceNamespace};

namespace {TargetNamespace}.Tests;

public class {ClassName}Tests
{
    private readonly Mock<{IDependency}> _mockDependency;
    private readonly {ClassName} _sut;

    public {ClassName}Tests()
    {
        _mockDependency = new Mock<{IDependency}>();
        _sut = new {ClassName}(_mockDependency.Object);
    }

    [Fact]
    public void {MethodName}_WhenValid_CallsDependencyAndReturnsExpected()
    {
        // Arrange
        _mockDependency
            .Setup(d => d.{DependencyMethod}({AnyParam}))
            .Returns({MockReturn});

        // Act
        var result = _sut.{MethodName}({Parameters});

        // Assert
        Assert.Equal({Expected}, result);
        _mockDependency.Verify(d => d.{DependencyMethod}({AnyParam}), Times.Once);
    }
}
```

## 非同期テストクラス（async Task）

```csharp
using Xunit;
using {TargetNamespace};

namespace {TargetNamespace}.Tests;

public class {ClassName}Tests
{
    private readonly {ClassName} _sut;

    public {ClassName}Tests()
    {
        _sut = new {ClassName}();
    }

    [Fact]
    public async Task {MethodName}Async_WhenValid_ReturnsExpected()
    {
        // Arrange
        {ArrangeCode}

        // Act
        var result = await _sut.{MethodName}Async({Parameters});

        // Assert
        Assert.Equal({Expected}, result);
    }

    [Fact]
    public async Task {MethodName}Async_WhenInvalid_ThrowsException()
    {
        // Arrange
        {InvalidArrangeCode}

        // Act & Assert
        await Assert.ThrowsAsync<{ExceptionType}>(
            () => _sut.{MethodName}Async({InvalidParameters})
        );
    }
}
```

## プレースホルダ一覧

| プレースホルダ | 置き換え内容 |
|--------------|------------|
| `{TargetNamespace}` | テスト対象の名前空間（例: `MyApp.Services`） |
| `{ClassName}` | テスト対象クラス名（例: `UserService`） |
| `{MethodName}` | テスト対象メソッド名（例: `GetUser`） |
| `{IDependency}` | 依存インターフェース名（例: `IUserRepository`） |
| `{DependencyMethod}` | モック対象のメソッド名 |
| `{ArrangeCode}` | テストデータの準備コード |
| `{Parameters}` | メソッド引数 |
| `{Expected}` | 期待値 |
| `{ParamType}` | `[Theory]` の入力型 |
| `{ReturnType}` | `[Theory]` の戻り値型 |
| `{ExceptionType}` | 期待する例外型（例: `ArgumentException`） |
