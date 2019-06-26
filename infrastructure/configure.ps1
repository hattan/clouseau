# Enable CORS on function app
az functionapp cors add -n azuresearchdemofn -g azuresearchdemo --allowed-origins *

#upload data file
az storage blob upload -f ..\data.json -c data --account-name azuresearchdemostore  -n data.json