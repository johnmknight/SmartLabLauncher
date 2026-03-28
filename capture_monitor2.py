from PIL import ImageGrab
import screeninfo

# Get all monitors
monitors = screeninfo.get_monitors()

print(f"Found {len(monitors)} monitors")

if len(monitors) > 1:
    # Get second monitor (index 1)
    monitor = monitors[1]
    print(f"Monitor 2: {monitor.width}x{monitor.height} at ({monitor.x}, {monitor.y})")
    
    # Capture the second monitor
    bbox = (monitor.x, monitor.y, monitor.x + monitor.width, monitor.y + monitor.height)
    screenshot = ImageGrab.grab(bbox=bbox)
    
    # Save to file
    output_path = r"C:\Users\john_\dev\SmartLabLauncher\monitor2_screenshot.png"
    screenshot.save(output_path)
    
    print(f"Screenshot saved to: {output_path}")
    print(f"Image size: {screenshot.size}")
else:
    print("Second monitor not found")
    for i, m in enumerate(monitors):
        print(f"Monitor {i}: {m.width}x{m.height} at ({m.x}, {m.y})")
