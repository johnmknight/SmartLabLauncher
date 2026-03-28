Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Get all screens
$screens = [System.Windows.Forms.Screen]::AllScreens

Write-Host "Found $($screens.Count) monitors"

# Get the second monitor (index 1)
if ($screens.Count -gt 1) {
    $screen = $screens[1]
    $bounds = $screen.Bounds
    
    Write-Host "Monitor 2: $($bounds.Width)x$($bounds.Height) at $($bounds.X),$($bounds.Y)"
    
    # Create bitmap
    $bitmap = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    
    # Capture screen
    $graphics.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)
    
    # Save to file
    $path = 'C:\Users\john_\dev\SmartLabLauncher\monitor2_screenshot.png'
    $bitmap.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    
    Write-Host "Screenshot saved to: $path"
    Write-Host "Image size: $($bounds.Width)x$($bounds.Height)"
    
    $graphics.Dispose()
    $bitmap.Dispose()
} else {
    Write-Host 'Only one monitor detected'
    for ($i = 0; $i -lt $screens.Count; $i++) {
        $bounds = $screens[$i].Bounds
        Write-Host "Monitor $i : $($bounds.Width)x$($bounds.Height) at $($bounds.X),$($bounds.Y)"
    }
}
