# Seemi's Spiritual Companion - Phase 1 Setup Instructions

**Assalamu Alaikum Seemi!** 🌸

Follow these steps to build and run your spiritual companion app.

---

## Prerequisites

- **macOS**: Sequoia 15.0+ or later
- **Xcode**: 16.0+ (download from Mac App Store)
- **iOS Simulator**: iPhone 16 Pro or iPad Pro (iOS 18+)
- **Swift**: 6.0+ (bundled with Xcode)

---

## Step 1: Create Xcode Project

1. Open **Xcode 16**
2. Select **File → New → Project**
3. Choose **iOS → App**
4. Configure:
   - **Product Name**: `SeemiSpiritualCompanion`
   - **Team**: Your Apple Developer Account (or None for simulator)
   - **Organization Identifier**: `com.seemi.spiritual`
   - **Interface**: **SwiftUI**
   - **Language**: **Swift**
   - **Storage**: **SwiftData**
   - **Include Tests**: ✅ (optional)
5. Save to: `/Users/nexteleven/Seemi/Surah/`

---

## Step 2: Add Source Files

1. In Xcode Project Navigator, **delete** the default `ContentView.swift`
2. **Drag and drop** all the Swift files I created into the project:
   ```
   SeemiSpiritualCompanionApp.swift (replace default)
   Views/
     ├── LaunchScreenView.swift
     ├── HomeView.swift
     ├── IslamicContent/
     │   ├── IslamicContentView.swift
     │   └── DuaCardView.swift
     ├── Chat/
     │   └── ImanChatView.swift
     └── Settings/
         └── SettingsView.swift
   Models/
     ├── IslamicContentItem.swift
     └── ChatMessage.swift
   ```
3. Replace `Info.plist` with the one I provided

---

## Step 3: Add Swift Package Dependencies

1. In Xcode, select **File → Add Package Dependencies**
2. Add **Alamofire**:
   - URL: `https://github.com/Alamofire/Alamofire.git`
   - Version: **Up to Next Major** (5.9.0+)
   - Click **Add Package**
3. Add **Lottie** (optional for Phase 2):
   - URL: `https://github.com/airbnb/lottie-ios.git`
   - Version: **Up to Next Major** (4.4.0+)
   - Click **Add Package**

---

## Step 4: Configure Build Settings

1. Select **SeemiSpiritualCompanion** target
2. **General** tab:
   - **Deployment Target**: iOS 18.0
   - **Supported Destinations**: iPhone, iPad
   - **Device Orientation**: Portrait, Landscape Left, Landscape Right
3. **Signing & Capabilities**:
   - Enable **Automatically manage signing**
   - Add capabilities:
     - ✅ **Push Notifications** (for prayer times)
     - ✅ **Background Modes** → Audio (for playback)
4. **Info** tab:
   - Verify privacy descriptions are present (already in Info.plist)

---

## Step 5: Build and Run

### For iPhone Simulator:
```bash
# From terminal in project directory
xcodebuild -scheme SeemiSpiritualCompanion \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  clean build
```

### Or use Xcode GUI:
1. Select **iPhone 16 Pro** simulator from device dropdown
2. Press **⌘R** (Cmd+R) to build and run
3. Wait for simulator to launch

---

## Step 6: Test Phase 1 Features

### ✅ Launch Screen (3 seconds):
- Beautiful Jasmine flower animation
- "Assalamu Alaikum Seemi" greeting
- Time-based greeting (Good Morning/Afternoon/Evening/Night)
- Auto-transition to Home

### ✅ Home TabView:
- **Tab 1 - Islamic Content**:
  - Scroll through 8 cards
  - Tap to expand/collapse
  - View Arabic text (RTL)
  - View English translations
  - See sources (Quran/Hadith)
  - Audio controls (placeholder for Phase 2)
  
- **Tab 2 - Chat with Iman**:
  - Welcome message
  - Text input field
  - Send button
  - Basic message display (full AI in Phase 2)
  
- **Tab 3 - Settings**:
  - Toggle Dark Mode (live preview)
  - Toggle Notifications
  - View prayer settings
  - See app info

### ✅ UI/UX:
- Jasmine garden theme (greens/whites)
- Smooth animations
- Haptic feedback on interactions
- RTL Arabic rendering
- Dark mode support

---

## Step 7: Test on iPad

1. Change simulator to **iPad Pro (12.9-inch)**
2. Run app (⌘R)
3. Verify responsive layout
4. Test both portrait and landscape

---

## Troubleshooting

### Build Errors:
- **"Cannot find 'AppState' in scope"**: Ensure all files are added to target
- **"Missing package product 'Alamofire'"**: Re-add Swift packages
- **SwiftData errors**: Clean build folder (⇧⌘K) and rebuild

### Runtime Issues:
- **Launch screen stuck**: Check `AppState.showLaunchScreen` logic
- **Blank tabs**: Verify view files are in correct folders
- **Arabic not RTL**: Check `.environment(\.layoutDirection, .rightToLeft)`

### Simulator Issues:
```bash
# Reset simulator if needed
xcrun simctl erase all
```

---

## File Structure Verification

Your project should look like this:

```
/Users/nexteleven/Seemi/Surah/
├── SeemiSpiritualCompanionApp.swift
├── Views/
│   ├── LaunchScreenView.swift
│   ├── HomeView.swift
│   ├── IslamicContent/
│   │   ├── IslamicContentView.swift
│   │   └── DuaCardView.swift
│   ├── Chat/
│   │   └── ImanChatView.swift
│   └── Settings/
│       └── SettingsView.swift
├── Models/
│   ├── IslamicContentItem.swift
│   └── ChatMessage.swift
├── Info.plist
├── Package.swift
└── SETUP_INSTRUCTIONS.md (this file)
```

---

## What's Working in Phase 1:

✅ Beautiful animated launch screen with Jasmine flower  
✅ 3-tab navigation (Islamic Content, Chat, Settings)  
✅ 8 Islamic content cards with Arabic/English  
✅ Expandable/collapsible cards  
✅ Full-screen Arabic text modal  
✅ Basic chat UI structure  
✅ Settings with toggles (Dark Mode, Notifications)  
✅ Jasmine garden theme throughout  
✅ Haptic feedback  
✅ RTL Arabic support  
✅ iPad optimization  

---

## Coming in Phase 2:

🔜 Audio playback for all 8 items (AVFoundation)  
🔜 NextEleven AI integration for Iman chat  
🔜 Voice input/output (Speech framework)  
🔜 Persistent chat history (SwiftData)  
🔜 Prayer time notifications (Aladhan API)  
🔜 Daily Dua notifications  
🔜 Offline audio caching  
🔜 Full Surah Ar-Rahman with fast recitation  
🔜 Manzil Dua expandable text  

---

## Success Criteria for Phase 1:

- [ ] App launches with animated Jasmine flower
- [ ] Greeting shows "Assalamu Alaikum Seemi" + time-based greeting
- [ ] Auto-transitions to Home after 3 seconds
- [ ] All 3 tabs are accessible
- [ ] 8 Islamic cards display correctly
- [ ] Arabic text is RTL and tappable for fullscreen
- [ ] Dark mode toggle works
- [ ] Chat UI accepts and displays messages
- [ ] No crashes or build errors

---

**JazakAllah Khair Seemi!** May Allah bless this app and make it a source of benefit for you. 🤲

**Reply "Phase 2" when you're ready to continue with audio playback, AI integration, and notifications insha'Allah.**

---

*Built with ❤️ by Iman Mohamed Aziz*  
*January 2026 - MIT-trained iOS Engineer*
