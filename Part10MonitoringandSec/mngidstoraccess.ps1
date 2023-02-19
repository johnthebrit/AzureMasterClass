#Using Az module
Connect-AzAccount -Identity #Connect as the managed identity
$storcontext = New-AzStorageContext -StorageAccountName 'sascussavilltech' -UseConnectedAccount
Get-AzStorageBlobContent -Container 'images' -Blob 'OllieandEddieCerealEating.jpg' `
    -Destination "C:\test\" -Context $storcontext

#Integrate with Key Vault using token directly
$response = Invoke-WebRequest -Uri 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://vault.azure.net' -Method GET -Headers @{Metadata="true"}
$content = $response.Content | ConvertFrom-Json
$Token = $content.access_token

(Invoke-WebRequest -Uri https://savillvaultrbac.vault.azure.net/secrets/Secret1?api-version=2016-10-01 -Method GET -Headers @{Authorization="Bearer $Token"}).content
