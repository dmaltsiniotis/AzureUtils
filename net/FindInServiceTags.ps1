param (
    [string]
    $ipAddress
)

$service_tags_filename = "ServiceTags.json"
$service_tags_url = "https://download.microsoft.com/download/7/1/d/71d86715-5596-4529-9b13-da13a5de5b63/ServiceTags_Public_20250414.json"

function Get-ServiceTags {
    if (-Not (Test-Path -Path $service_tags_filename)) {
        Invoke-WebRequest -Uri $service_tags_url -OutFile $service_tags_filename
    }
}

function Test-IpInCidr {
    param (
        [string]$cidr,
        [string]$ipAddress
    )

    # Helper function to convert IP address to a 32-bit number
    function ConvertTo-IpNumber {
        param (
            [string]$ip
        )
        $bytes = [System.Net.IPAddress]::Parse($ip).GetAddressBytes()
        [Array]::Reverse($bytes)
        return [BitConverter]::ToUInt32($bytes, 0)
    }

    # Split the CIDR into base IP and prefix length
    $cidrParts = $cidr -split "/"
    $baseIp = $cidrParts[0]
    $prefixLength = [int]$cidrParts[1]

    # Convert IPs to numbers
    $baseIpNumber = ConvertTo-IpNumber -ip $baseIp
    $ipNumber = ConvertTo-IpNumber -ip $ipAddress

    # Calculate the subnet mask
    $subnetMask = [uint32]::MaxValue -shl (32 - $prefixLength)

    # Check if the IP falls within the CIDR range
    if (($baseIpNumber -band $subnetMask) -eq ($ipNumber -band $subnetMask)) {
        return $true
    } else {
        return $false
    }
}

function Find-InServiceTags {
    param (
        [string]$ipAddress
    )

    $jsonContent = Get-Content -Path $service_tags_filename -Raw | ConvertFrom-Json
    Write-Host "Searching for $ipAddress in all Azure service tags..."
    foreach ($value in $jsonContent.values) {
        foreach ($prefix in $value.properties.addressPrefixes) {
            if (Test-IpInCidr -cidr $prefix -ipAddress $ipAddress) {
                Write-Host "$ipaddress was found in $prefix which belongs to service tag: $($value.name)"
            }
        }
    }
}

Get-ServiceTags
Find-InServiceTags -ipAddress $ipAddress