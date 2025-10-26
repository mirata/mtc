$sourceDirectory = ".\src"
$outputPk3 = ".\dist\mtc.pk3"

Compress-Archive -Path "$sourceDirectory\*" -DestinationPath $outputPk3 -Force