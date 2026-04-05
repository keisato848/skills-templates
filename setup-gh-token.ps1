#!/usr/bin/env pwsh
# setup-gh-token.ps1
# GitHub CLI に project スコープ付き PAT を設定する。
# 一度実行すれば以降は再認証不要。
#
# 事前準備:
#   1. https://github.com/settings/tokens?type=beta (Fine-grained) または
#      https://github.com/settings/tokens (Classic) でトークンを作成
#   2. Classic PAT の場合: repo / read:org / gist / project にチェック
#   3. Fine-grained PAT の場合: Projects (read/write) にチェック
#   4. 作成したトークンを控えておく

param(
    [string]$Token
)

if (-not $Token) {
    Write-Host ""
    Write-Host "============================================"
    Write-Host " GitHub CLI project スコープ設定ツール"
    Write-Host "============================================"
    Write-Host ""
    Write-Host "PAT（Personal Access Token）が必要です。"
    Write-Host "まだ持っていない場合は以下で作成してください:"
    Write-Host ""
    Write-Host "  Classic PAT:"
    Write-Host "  https://github.com/settings/tokens"
    Write-Host "  必要スコープ: repo, read:org, gist, project"
    Write-Host ""
    Write-Host "  Fine-grained PAT:"
    Write-Host "  https://github.com/settings/tokens?type=beta"
    Write-Host "  必要権限: Projects (read/write)"
    Write-Host ""
    $Token = Read-Host "PAT を貼り付けてください"
}

if (-not $Token) {
    Write-Error "トークンが入力されませんでした。"
    exit 1
}

# token を gh CLI に設定
$Token | gh auth login --with-token --hostname github.com

if ($LASTEXITCODE -ne 0) {
    Write-Error "ログイン失敗。トークンを確認してください。"
    exit 1
}

# スコープ確認
$status = gh auth status 2>&1
Write-Host ""
Write-Host "--- 認証状態 ---"
$status | Write-Host

if ($status -match "project") {
    Write-Host ""
    Write-Host "✅ project スコープが確認されました。設定完了です。"
} else {
    Write-Host ""
    Write-Host "⚠️  project スコープが見当たりません。"
    Write-Host "   PAT 作成時に 'project' スコープにチェックが入っているか確認してください。"
}
