# App Icon Instructions

## How to Add Your App Icon

1. **Prepare Your Icon:**
   - Create a 1024x1024 pixel PNG image
   - Use a square image (no rounded corners - iOS will add them)
   - Recommended: Transparent background or solid color
   - File name: `AppIcon.png` (or any name you prefer)

2. **Add to Xcode:**
   - Open your project in Xcode
   - In the Project Navigator, find `Assets.xcassets`
   - Click on `AppIcon`
   - Drag and drop your 1024x1024 icon into the "App Store" slot (or the universal 1024x1024 slot)
   - Xcode will automatically generate all required sizes

3. **Or Add Manually:**
   - Place your icon file in this folder: `Assets.xcassets/AppIcon.appiconset/`
   - Name it: `AppIcon-1024.png`
   - Update `Contents.json` to reference it:
   ```json
   {
     "images" : [
       {
         "filename" : "AppIcon-1024.png",
         "idiom" : "universal",
         "platform" : "ios",
         "size" : "1024x1024"
       }
     ],
     "info" : {
       "author" : "xcode",
       "version" : 1
     }
   }
   ```

4. **Build and Test:**
   - Clean build folder (⌘ShiftK)
   - Build project (⌘B)
   - Run on simulator or device
   - Check that icon appears on home screen

## Icon Design Tips

- **Simple and recognizable:** Should be clear even at small sizes
- **No text:** Avoid text in the icon (it will be too small to read)
- **High contrast:** Make sure it stands out on various backgrounds
- **Jasmine theme:** Consider using green (#66BB6A) and white colors to match your app
- **Islamic elements:** Subtle Islamic patterns or symbols work well

## Required Sizes (iOS automatically generates these from 1024x1024)

- 20x20 (Notification)
- 29x29 (Settings)
- 40x40 (Spotlight)
- 60x60 (App)
- 76x76 (iPad)
- 83.5x83.5 (iPad Pro)
- 1024x1024 (App Store)
