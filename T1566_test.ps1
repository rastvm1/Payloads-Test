# Define the command to be executed
$command_to_run = "calc.exe"

# Add user32.dll for keybd_event
Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class K {
        [DllImport("user32.dll")]
        public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
    }
"@

# Virtual key codes
$VK_LWIN, $VK_R, $KEYDOWN, $KEYUP = 0x5B, 0x52, 0x0000, 0x0002

# Open Run dialog (Win+R)
[K]::keybd_event($VK_LWIN, 0, $KEYDOWN, [UIntPtr]::Zero)
[K]::keybd_event($VK_R, 0, $KEYDOWN, [UIntPtr]::Zero)
[K]::keybd_event($VK_R, 0, $KEYUP, [UIntPtr]::Zero)
[K]::keybd_event($VK_LWIN, 0, $KEYUP, [UIntPtr]::Zero)

# Short delay for Run dialog
Start-Sleep -Milliseconds 500
Add-Type -AssemblyName System.Windows.Forms

# Encode the command and send it to the Run dialog
$encoded_command = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($command_to_run))
[System.Windows.Forms.SendKeys]::SendWait("cmd /c powershell -ec " + $encoded_command + "{ENTER}")