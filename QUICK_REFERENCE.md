# Quick Reference Card 🚀

**Seemi's Spiritual Companion - Phase 1**

---

## 🏃‍♀️ Quick Start (5 Minutes)

1. **Open Xcode 16** → New Project → iOS App
2. **Name**: `SeemiSpiritualCompanion`
3. **Drag files** from `/Users/nexteleven/Seemi/Surah/` into Xcode
4. **Add packages**: Alamofire + Lottie
5. **Build** (⌘R) on iPhone 16 Pro simulator
6. **Test** launch screen → tabs → cards → chat → settings

---

## 📂 File Structure (13 Files)

```
App:      SeemiSpiritualCompanionApp.swift
Views:    LaunchScreenView, HomeView, IslamicContentView, 
          DuaCardView, ImanChatView, SettingsView
Models:   IslamicContentItem, ChatMessage
Config:   Info.plist, Package.swift, .gitignore
Docs:     README, SETUP_INSTRUCTIONS, TESTING_CHECKLIST, 
          WIREFRAMES, PHASE1_COMPLETE, QUICK_REFERENCE
```

---

## 🎨 Color Palette

```
Primary:      #66BB6A  (Green buttons/accents)
Dark Green:   #1B5E20  (Text/headings)
Background:   #F1F8E9  (Light green wash)
White:        #FFFFFF  (Cards)
Orange:       #F57C00  (Repeat badges)
```

---

## 📱 Key Features

### Launch Screen (3s):
- Animated Jasmine flower (8 petals + center)
- "Assalamu Alaikum Seemi" + time greeting
- Auto-transition to Home

### Islamic Content (Tab 1):
- 8 cards: Duas + Surah Ar-Rahman + Manzil
- RTL Arabic (22pt) + English translation
- Expand/collapse + fullscreen modal
- Audio placeholder (Phase 2)

### Chat (Tab 2):
- Messages-style UI
- User (green) + Bot (white) bubbles
- Text input + send button
- AI integration (Phase 2)

### Settings (Tab 3):
- Dark Mode toggle (live)
- Notifications toggle
- Prayer settings (Lahore PKT)
- About + Clear history

---

## 🔧 Tech Stack

```
Language:     Swift 6.0
Framework:    SwiftUI 6
Persistence:  SwiftData
Networking:   Alamofire 5.9+
Animations:   Lottie 4.4+ (optional)
Min iOS:      18.0
Xcode:        16.0+
```

---

## ✅ Testing Checklist

- [ ] Launch animation smooth
- [ ] All 3 tabs accessible
- [ ] 8 cards display correctly
- [ ] Arabic is RTL
- [ ] Cards expand/collapse
- [ ] Chat sends messages
- [ ] Dark mode works
- [ ] No crashes

---

## 🎯 Phase 1 vs Phase 2

### ✅ Phase 1 (DONE):
- UI/UX complete
- Navigation structure
- 8 Islamic cards
- Chat interface
- Settings screen
- Dark mode

### 🔄 Phase 2 (NEXT):
- Audio playback (AVFoundation)
- NextEleven AI chat
- Voice input/output
- Prayer notifications
- Dua reminders
- Offline caching

---

## 🐛 Troubleshooting

### Build Errors:
```
"Cannot find AppState"
→ Add all files to target

"Missing Alamofire"
→ Re-add Swift packages

SwiftData errors
→ Clean build (⇧⌘K)
```

### Runtime Issues:
```
Launch screen stuck
→ Check AppState.showLaunchScreen

Blank tabs
→ Verify files in correct folders

Arabic not RTL
→ Check .environment(\.layoutDirection, .rightToLeft)
```

---

## 📚 8 Islamic Items

1. **Dua to Remove Worry** (Musnad Ahmad)
2. **Protection Dua** (Abu Dawud) - 3x
3. **Surah Ar-Rahman** (Quran 55)
4. **Dua for Tension** (Quran 65:3)
5. **Wazifa Protection** (Abu Dawud) - 3x
6. **Dua for Healing** (Quran 17:82)
7. **Dua Against Evil Eye** (Quran 113)
8. **Manzil Dua** (33 ayahs)

---

## 🎨 Design Tokens

### Typography:
```
Arabic:       22pt, Medium, RTL
Headings:     20-28pt, Semibold
Body:         16pt, Regular
Captions:     12-14pt, Regular
```

### Spacing:
```
Card padding:     20pt
Card spacing:     20pt
Screen padding:   16pt
Safe area:        Auto
```

### Animations:
```swift
.spring(response: 0.4, dampingFraction: 0.8)
```

### Haptics:
```swift
UIImpactFeedbackGenerator(.light)   // Tabs
UIImpactFeedbackGenerator(.medium)  // Cards
```

---

## 🔐 Privacy

- ✅ No analytics
- ✅ Local storage only
- ✅ Keychain for API keys (Phase 2)
- ✅ Minimal permissions

---

## 📞 Support

1. Read `SETUP_INSTRUCTIONS.md`
2. Check `PHASE1_TESTING_CHECKLIST.md`
3. Review `WIREFRAMES.md`
4. See `PHASE1_COMPLETE.md`

---

## 🚀 Next Steps

**After testing Phase 1, reply:**

```
Phase 2
```

**To implement:**
- 🎵 Audio playback
- 🤖 AI integration
- 🎤 Voice features
- 🔔 Notifications

---

## 🤲 Dua

*"O Allah, bless this app and make it beneficial. Ameen."*

---

**Built for Seemi Warris exclusively**  
**By Iman Mohamed Aziz | January 2026**  
**MIT-trained iOS Engineer**

🌸 **Assalamu Alaikum!** 🌸
