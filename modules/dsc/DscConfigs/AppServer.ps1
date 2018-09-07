Configuration AppServer {

    Import-DscResource -Module cChoco
    Import-DscResource -ModuleName StorageDsc

    $dataDiskLatter = "F"

    Node MirrorCheck {
        
        cChocoInstaller Choco {
            InstallDir = "c:\choco"
        }

        cChocoPackageInstallerSet Packages {
            DependsOn = "[cChocoInstaller]Choco"
            Ensure = "Present"
            Name = @(
                "notepadplusplus", 
                "azure-cli", 
                "azurepowershell"
                )
        }

        WaitForDisk DataDisk {
            DiskId = "2"
            RetryIntervalSec = 60
            RetryCount = 100
        }

        Disk DataDisk {
            DependsOn = "[WaitForDisk]DataDisk"
            DriveLetter = $dataDiskLatter
            AllowDestructive = $false
            DiskId = "2"
        }
    }
}