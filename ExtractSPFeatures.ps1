# Solution name | solutionId | feature name | featureId | hidden | compatibility level | scope | url | activated
# Solution name | solutionId | url | activated
Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue


$featureStatus = @()

$features = Get-SPFeature | Group-Object Id | ForEach-Object {$_.Group | Select-Object -First 1}
$solutions = Get-SPSolution

$farmActiveFeatures = Get-SPFeature -Farm
$farm = Get-SPFarm

$webapplications = Get-SPWebApplication 
$sites = Get-SPSite -Limit all
$webs = Get-SPSite -Limit all|Get-SPWeb -Limit all

# farmfeatures 

foreach ($feature in ($features|Where-Object {$_.Scope -eq "Farm"})){
$properties = @{}
$solution = $solutions | Where-Object { $_.SolutionId -eq $feature.SolutionId }

   $properties.Add('FeatureInternalName',$feature.DisplayName)
   $properties.Add('FeatureDisplayName',$feature.GetTitle(1033))
   $properties.Add('FeatureId',$feature.Id)
   $properties.Add('CompatibitlityLevel',$feature.CompatibilityLevel)
   $properties.Add('FeatureScope',$feature.Scope)
   $properties.Add('Hidden',$feature.Hidden)
   $properties.Add('ScopeEntityId',$farm.Id)
   $properties.Add('SolutionName', $solution.Name)
   $properties.Add('SolutionID', $solution.SolutionId)

   if($feature.Scope -eq "Farm"){
    $properties.Add('Url',$null)

    $isActive = if (($farmActiveFeatures | Where-Object {$_.Id -eq $feature.Id}) -ne $null) {Write-Output $true} else {Write-Output $false}
    $properties.Add('Active',$isActive)

    $object = New-Object -TypeName PSObject -Property $properties
    $featureStatus+=$object


   }
}

foreach ($webapplication in $webapplications){

$webappActiveFeatures = Get-SPFeature -WebApplication $webapplication.Url

foreach($feature in ($features|Where-Object {$_.Scope -eq "WebApplication"})){

$properties = @{}
$solution = $solutions | Where-Object { $_.SolutionId -eq $feature.SolutionId }

   $properties.Add('FeatureInternalName',$feature.DisplayName)
   $properties.Add('FeatureDisplayName',$feature.GetTitle(1033))
   $properties.Add('FeatureId',$feature.Id)
   $properties.Add('CompatibitlityLevel',$feature.CompatibilityLevel)
   $properties.Add('FeatureScope',$feature.Scope)
   $properties.Add('Hidden',$feature.Hidden)
   $properties.Add('ScopeEntityId',$webapplication.Id)
   $properties.Add('SolutionName', $solution.Name)
   $properties.Add('SolutionID', $solution.SolutionId)

   if($feature.Scope -eq "WebApplication"){
    $properties.Add('Url',$null)

    $isActive = if (($webappActiveFeatures | Where-Object {$_.Id -eq $feature.Id}) -ne $null) {Write-Output $true} else {Write-Output $false}
    $properties.Add('Active',$isActive)

    $object = New-Object -TypeName PSObject -Property $properties
    $featureStatus+=$object


   }

   }

}

foreach ($site in $sites){

$siteActiveFeatures = Get-SPFeature -Site $site.Url

foreach($feature in ($features|Where-Object {$_.Scope -eq "Site"})){

$properties = @{}
$solution = $solutions | Where-Object { $_.SolutionId -eq $feature.SolutionId }

   $properties.Add('FeatureInternalName',$feature.DisplayName)
   $properties.Add('FeatureDisplayName',$feature.GetTitle(1033))
   $properties.Add('FeatureId',$feature.Id)
   $properties.Add('CompatibitlityLevel',$feature.CompatibilityLevel)
   $properties.Add('FeatureScope',$feature.Scope)
   $properties.Add('Hidden',$feature.Hidden)
   $properties.Add('ScopeEntityId',$site.Id)
   $properties.Add('SolutionName', $solution.Name)
   $properties.Add('SolutionID', $solution.SolutionId)
   

   if($feature.Scope -eq "Site"){
    $properties.Add('Url',$site.Url)

    $isActive = if (($siteActiveFeatures | Where-Object {$_.Id -eq $feature.Id}) -ne $null) {Write-Output $true} else {Write-Output $false}
    $properties.Add('Active',$isActive)

    $object = New-Object -TypeName PSObject -Property $properties
    $featureStatus+=$object


   }

   }

}

foreach ($web in $webs){

$webActiveFeatures = Get-SPFeature -Site $web.Url

foreach($feature in ($features|Where-Object {$_.Scope -eq "Web"})){

$properties = @{}
$solution = $solutions | Where-Object { $_.SolutionId -eq $feature.SolutionId }

   $properties.Add('FeatureInternalName',$feature.DisplayName)
   $properties.Add('FeatureDisplayName',$feature.GetTitle(1033))
   $properties.Add('FeatureId',$feature.Id)
   $properties.Add('CompatibitlityLevel',$feature.CompatibilityLevel)
   $properties.Add('FeatureScope',$feature.Scope)
   $properties.Add('Hidden',$feature.Hidden)
   $properties.Add('ScopeEntityId',$web.Id)
   $properties.Add('SolutionName', $solution.Name)
   $properties.Add('SolutionID', $solution.SolutionId)

   if($feature.Scope -eq "Web"){
    $properties.Add('Url',$web.Url)

    $isActive = if (($webActiveFeatures | Where-Object {$_.Id -eq $feature.Id}) -ne $null) {Write-Output $true} else {Write-Output $false}
    $properties.Add('Active',$isActive)

    $object = New-Object -TypeName PSObject -Property $properties
    $featureStatus+=$object


   }

   }

}


$featureStatus|Export-csv c:\ALLfeaturesSolutions.csv -Force

