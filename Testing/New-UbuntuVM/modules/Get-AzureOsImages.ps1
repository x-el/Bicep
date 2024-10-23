$OsType = "Linux"
$resourceLocation = "westeurope"

if ($OsType -eq "Linux") {
    $publisherName = "Canonical"
    $availableOffers = Get-AzVMImageOffer -Location $resourceLocation -PublisherName $publisherName | Where-Object {$_.Offer -like "0001-com-ubuntu-server-*"}
    ForEach ($currentOffer in $availableOffers) {
        $currentSkus = Get-AzVMImageSku -Location $resourceLocation -PublisherName $publisherName -Offer $currentOffer.Offer | Where-Object {$_.Skus -like "*-lts-gen2"}
        $currentSkus | Format-Table Skus,Offer -AutoSize
    }
}

elseif ( $OsType -eq "WindowsClient") {
    $publisherName = "Windows"
}
else {
    $publisherName = "MicrosoftWindowsServer"
    $offerName = "WindowsServer"
    # $availableOffers = Get-AzVMImageOffer -Location $resourceLocation -PublisherName $publisherName
    $currentSkus = Get-AzVMImageSku -Location $resourceLocation -PublisherName $publisherName -Offer $offerName
    $currentSkus | Format-Table Skus,Offer -AutoSize
}