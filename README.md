# AzureUtils

A collection of scripts and utilities to help with common Azure tasks.

## Net

### FindInServiceTags.ps1

This PowerShell script accepts and IP address as a parameter and will return any Azure service tags CIDRs that IP address belongs to.

If the JSON file of all the Azure service tags does not exist in the relative directory, the script will attempt to download the JSON file and save it to `ServiceTags.json`. This URL may need to be modified from time to time to match the current download URL published on this page: [Azure IP Ranges and Service Tags – Public Cloud](https://www.microsoft.com/en-us/download/details.aspx?id=56519)

Example usage:

```PowerShell
.\FindInServiceTags.ps1 -ipAddress "20.44.17.221"
```

Example Output:

```text
Searching for 20.44.17.221 in all Azure service tags...
20.44.17.221 was found in 20.44.17.220/30 which belongs to: ActionGroup
20.44.17.221 was found in 20.44.17.220/30 which belongs to: ActionGroup.EastUS2
20.44.17.221 was found in 20.44.16.0/21 which belongs to: AzureCloud.eastus2
20.44.17.221 was found in 20.44.16.0/21 which belongs to: AzureCloud
```
