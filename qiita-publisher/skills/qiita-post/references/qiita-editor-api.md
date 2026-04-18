# Qiita エディタ操作 API リファレンス

Qiita 記事エディタは CodeMirror ベースで実装されている。
通常の DOM 操作（`type_in_page` 等）では正しく動作しないため、以下の API を使用する。

## 本文の全文入力・差し替え

Qiita エディタの本文欄（CodeMirror）にテキストを入力するには、
エディタ要素の内部 API を使って `dispatch` でトランザクションを送る。

### 手順

1. CodeMirror エディタ要素を取得する:

```javascript
// 本文エディタの textarea を含むコンテナ要素を取得
const el = document.querySelector('.cm-editor')?.closest('[class*="cm"]');
// または role="textbox" の要素を探す
const el = document.querySelector('[role="textbox"]');
```

2. `cmTile.view` 経由で全文差し替えを実行:

```javascript
const view = el.cmTile.view;
const currentDoc = view.state.doc;
const text = `ここに記事本文を入れる`;

view.dispatch({
  changes: {
    from: 0,
    to: currentDoc.length,
    insert: text
  }
});
```

### 注意事項

- `el.cmTile` は Qiita 固有のプロパティ。標準の CodeMirror API ではない
- `type_in_page` を使うと、既存テキストの後ろに追記される、または部分的にしか入力されない
- 全文差し替えでは `from: 0, to: currentDoc.length` とすることで確実にクリア＆入力できる
- エスケープが必要な文字に注意: バッククォート、バックスラッシュ等は文字列リテラル内で正しくエスケープする

## タイトル入力

タイトルは通常の HTML input 要素。`type_in_page` または `fill_form` で入力可能。

```
// セレクタ例
input[placeholder*="タイトル"]
```

## タグ入力

タグはテキスト入力欄にスペース区切りで入力する。

```
// 入力例: "MCP TypeScript デザインシステム アクセシビリティ GitHubCopilot"
```

### タグ有効性の確認

入力されたタグが Qiita に認識されると、各タグが緑色の span 要素で表示される:
- 背景色: `var(--color-greenContainerVariant)` 系
- 各タグが個別の span として分離表示される

緑色にならないタグは Qiita に存在しないか、スペル違いの可能性がある。

## ボタン操作

| 操作 | ボタンテキスト | 備考 |
|------|--------------|------|
| 下書き保存 | 「下書きを保存する」 | 新規・編集とも同じ |
| 公開設定 | 「公開設定へ」 | モーダルが開く |
| キャンペーン登録 | 「登録する」 | モーダル内、該当キャンペーン横 |
| 記事投稿 | 「記事を投稿する」 | モーダル内 |

## URL パターン

| 状態 | URL パターン |
|------|-------------|
| 新規下書き | `https://qiita.com/drafts/new` |
| 下書き編集 | `https://qiita.com/drafts/<id>/edit` |
| 公開記事 | `https://qiita.com/<username>/items/<id>` |

投稿成功の判定: URL が `/drafts/` から `/<username>/items/` に遷移すれば成功。
