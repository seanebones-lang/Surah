# Tomorrow's Checklist - Text Visibility Issue

## Current Status
The text visibility issue persists on physical device despite multiple fixes.

## What We've Tried
1. ✅ Changed `.secondary` text to darker green `#558B2F`
2. ✅ Changed backgrounds from `Color.white` to `Color(UIColor.secondarySystemGroupedBackground)`
3. ✅ Added app icon to project
4. ✅ All changes committed to main branch
5. ✅ Archive created successfully

## Issue Still Present
- Subtitle text (like "Musnad Ahmad 1/391") appears very light/invisible on light green card backgrounds
- This suggests the color might not be applying correctly or there's a different issue

## Things to Try Tomorrow

### Option 1: Force Explicit Colors Everywhere
Instead of using system colors, use explicit hex colors for ALL text:
- Titles: `#1B5E20` (dark green)
- Body text: `#2E7D32` (medium dark green)  
- Subtitles: `#424242` (dark gray) - might be more readable than green

### Option 2: Check Card Background Color
The card background might be the issue. Currently using:
```swift
.background(Color(UIColor.secondarySystemGroupedBackground))
```
Try changing to explicit white or light color:
```swift
.background(Color(hex: "#FAFAFA"))
```

### Option 3: Increase Font Weight
Make subtitle text bolder:
```swift
.font(.system(size: 14, weight: .semibold))  // instead of .regular
```

### Option 4: Check Device Settings
- Verify device is not in High Contrast mode
- Check Accessibility settings
- Try on different physical device if available

## Files to Check
- `/Users/nexteleven/Seemi/Surah/Views/IslamicContent/DuaCardView.swift` - Line 27-29 (source text)
- `/Users/nexteleven/Seemi/Surah/Views/IslamicContent/IslamicContentView.swift` - Background gradient

## Quick Test Code
Add this to DuaCardView line 29 to force black text:
```swift
.foregroundStyle(Color.black)
```

If black text shows up, then the color system is working and we just need the right shade.

## Archive Location
Fresh archive ready at: `~/Desktop/SeemiSpiritualCompanion.xcarchive`

---
Good luck tomorrow! 🙏
