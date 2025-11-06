# --- Define the list of extension IDs to be installed ---
# These are for "Office Editing" and "Google Docs Offline"
$extList = @(
    "gbkeegbaiigmenfmjfclcdgdpimamgkj",
    "ghbmnnjooekpmoecnnnilnnbdlolhkhi"
)

# 1. Loop through each ID and create the required registry keys
foreach ($extension in $extList) {
  # Create the extension's key
  New-Item -Path "HKLM:\Software\Wow6432Node\Google\Chrome\Extensions\$extension" -Force
  
  # Add the 'update_url' property to force the installation
  New-ItemProperty -Path "HKLM:\Software\Wow6432Node\Google\Chrome\Extensions\$extension" -Name "update_url" -Value "https://clients2.google.com/service/update2/crx" -PropertyType "String" -Force
}

# 2. Start Chrome. Chrome will read the registry on startup and install the extensions.
Write-Host "Starting Chrome to force extension install..."
Start-Process chrome

# 3. Wait for 30 seconds to give Chrome time to process the install
Start-Sleep -Seconds 30

# 4. Stop Chrome.
Write-Host "Stopping Chrome."
Stop-Process -Name "chrome" -Force

Write-Host "Test complete. Check Chrome > Extensions to verify."