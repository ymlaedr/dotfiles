@REM -----------------------------------------------------------------------------
@REM 定数定義
@REM -----------------------------------------------------------------------------



@REM -----------------------------------------------------------------------------
@REM 共通処理
@REM -----------------------------------------------------------------------------



@REM -----------------------------------------------------------------------------
@REM メイン処理
@REM -----------------------------------------------------------------------------
@REM scoopのインストール
powershell.exe -ExecutionPolicy RemoteSigned Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

@REM git,jq,wgetのインストール
scoop install git jq wget
