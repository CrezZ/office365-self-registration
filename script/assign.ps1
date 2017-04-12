#2016-01-07 - Updated the script with a new function to support nested groups.
#Import Required PowerShell Modules
#Note - the Script Requires PowerShell 3.0!

Import-Module MSOnline
  
#Office 365 Admin Credentials
$CloudUsername = 'user@test.onmicrosoft.com'
$CloudPassword = ConvertTo-SecureString '123123123' -AsPlainText -Force
$CloudCred = New-Object System.Management.Automation.PSCredential $CloudUsername, $CloudPassword
 
#Connect to Office 365 
Connect-MsolService -Credential $CloudCred
function Get-JDMsolGroupMember { 
    param(
        [CmdletBinding(SupportsShouldProcess=$true)]
        [Parameter(Mandatory=$true, ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [ValidateScript({Get-MsolGroup -ObjectId $_})]
        $ObjectId,
        [switch]$Recursive
    )
    begin {
        $MSOLAccountSku = Get-MsolAccountSku -ErrorAction Ignore -WarningAction Ignore
        if (-not($MSOLAccountSku)) {
            throw "Not connected to Azure AD, run Connect-MsolService"
        }
    } 
    process {
        $UserMembers = Get-MsolGroupMember -GroupObjectId $ObjectId -MemberObjectTypes User -All
        if ($PSBoundParameters['Recursive']) {
            $GroupsMembers = Get-MsolGroupMember -GroupObjectId $ObjectId -MemberObjectTypes Group -All
            $GroupsMembers | ForEach-Object -Process {
                $UserMembers += Get-JDMsolGroupMember -Recursive -ObjectId $_.ObjectId 
            }
        }
        Write-Output ($UserMembers | Sort-Object -Property EmailAddress -Unique) 
         
    }
    end {
     
    }
}
 
  
$Licenses = @{
                 'pak_student' = @{ 
                          LicenseSKU = 'OSU56:STANDARDWOFFPACK_STUDENT'
                          Group = 'office_students'
                        }                           
                 'pak_other' = @{ 
                          LicenseSKU = 'OSU56:STANDARDWOFFPACK_STUDENT'
                          Group = 'office_users'
                        }                           
                 'exchange_other' = @{ 
                          LicenseSKU = 'OSU56:EXCHANGEENTERPRISE_FACULTY'
                          Group = 'office_users'
                        }                           
#                 'exchange_students' = @{ 
#                          LicenseSKU = 'OSU56:EXCHANGEENTERPRISE_FACULTY'
#                          Group = 'office_students'
#                        }                           
#                 'project_student' = @{ 
#                          LicenseSKU = 'OSU56:PROJECTONLINE_PLAN_1_STUDENT'
#                          Group = 'office_students'
#                        }                           
                 'office_student' = @{ 
                          LicenseSKU = 'OSU56:OFFICESUBSCRIPTION_STUDENT'
                          Group = 'office_students'
                        }                                                                       
              
                 'office_prepod' = @{ 
                          LicenseSKU = 'OSU56:OFFICESUBSCRIPTION_FACULTY'
                          Group = 'office_prepods'
                        }
#                 'project_prepod' = @{ 
#                          LicenseSKU = 'OSU56:PROJECTONLINE_PLAN_1_FACULTY'
#                          Group = 'office_prepods'
#                        }
                 'pak_prepods' = @{ 
                          LicenseSKU = 'OSU56:STANDARDWOFFPACK_FACULTY'
                          Group = 'office_prepods'
                        }
                 'exchenge_alumni' = @{ 
                          LicenseSKU = 'OSU56:EXCHANGESTANDARD_ALUMNI'
                          Group = 'office_postdoc'
                        }

            }
$UsageLocation = 'RU'
  
foreach ($license in $Licenses.Keys) {
  
    $GroupName = $Licenses[$license].Group
    $GroupID = (Get-MsolGroup -All | Where-Object {$_.DisplayName -eq $GroupName}).ObjectId
    $AccountSKU = Get-MsolAccountSku | Where-Object {$_.AccountSKUID -eq $Licenses[$license].LicenseSKU}
    $lname = $Licenses[$license].LicenseSKU
    Write-Output "Checking for unlicensed $license users in group $GroupName with ObjectGuid $GroupID..."
  
#    $GroupMembers = (Get-JDMsolGroupMember -ObjectId $GroupID -Recursive | Where-Object {$_.IsLicensed -eq $false}).EmailAddress
    $GroupMembers = (Get-JDMsolGroupMember -ObjectId $GroupID -Recursive | get-MsolUser | Where {$_.Licenses.AccountSkuId -NotContains $lname}).UserPrincipalName

    if ($AccountSKU.ActiveUnits - $AccountSKU.consumedunits -lt $GroupMembers.Count) { 
        Write-Warning 'Not enough licenses for all users, please remove user licenses or buy more licenses'
      }
         
        foreach ($User in $GroupMembers) {
          Try {
	    #TODO  add checking if user already has license
            Set-MsolUser -UserPrincipalName $User -UsageLocation $UsageLocation -ErrorAction Stop -WarningAction Stop
            Set-MsolUserLicense -UserPrincipalName $User -AddLicenses $AccountSKU.AccountSkuId -ErrorAction Stop -WarningAction Stop
            Write-Output "Successfully licensed $User with $license"
          } catch {
            Write-Warning "Error when licensing $User`r`n$_"
            Write-Warning "License - $lname`r`n"
          }
          
        }
  
}