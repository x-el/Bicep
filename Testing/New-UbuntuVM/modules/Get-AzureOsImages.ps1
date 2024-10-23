$OsType = "Linux"
$resourceLocation = "westeurope"

if ($OsType -eq "Linux") {
    $publisherName = "Canonical"
}
elseif ( $OsType -eq "WindowsClient") {
    $publisherName = "Windows"
}
else {
    $publisherName = "MicrosoftWindowsServer"
}

$availableOffers = Get-AzVMImageOffer -Location $resourceLocation -PublisherName $publisherName
ForEach ($currentOffer in $availableOffers) {
    $currentSkus = Get-AzVMImageSku -Location $resourceLocation -PublisherName $publisherName -Offer $currentOffer.Offer
    ForEach ($currentSku in $currentSkus) {
        if (($OsType -eq "Linux") -and ($currentSku.Skus -like "*-lts-gen2")) {
            $currentSku | Format-Table Skus,Offer -AutoSize
        }
        else {
            $currentSkus | Format-Table Skus,Offer -AutoSize
        }
    }
}