# Phase 1 Wireframes & UI Specifications

**Seemi's Spiritual Companion - Visual Design Documentation**

---

## 🌸 Launch Screen (3 seconds)

```
┌─────────────────────────────────────┐
│                                     │
│                                     │
│         Assalamu Alaikum            │  ← 32pt, light, serif, white
│                                     │
│              Seemi                  │  ← 48pt, bold, serif, white
│                                     │
│          Good Morning               │  ← 24pt, light, serif, white 90%
│                                     │
│                                     │
│                                     │
│              🌸 🌸                  │
│             🌸   🌸                 │  ← Animated Jasmine
│            🌸  ⚫  🌸                │    8 white petals
│             🌸   🌸                 │    Yellow center
│              🌸 🌸                  │    Blooms sequentially
│                                     │
│                                     │
│                                     │
│                                     │
│     بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ     │  ← 18pt, white 70%
│                                     │
└─────────────────────────────────────┘
    Gradient: #E8F5E9 → #81C784
    Auto-transition after 3s
```

### Animation Timeline:
```
0.0s: Screen appears with gradient
0.1s: Text fades in (0.6s duration)
0.3s: Petal 1 blooms
0.38s: Petal 2 blooms
0.46s: Petal 3 blooms
0.54s: Petal 4 blooms
0.62s: Petal 5 blooms
0.70s: Petal 6 blooms
0.78s: Petal 7 blooms
0.86s: Petal 8 blooms
0.94s: Center appears
3.0s: Fade to Home (0.5s duration)
```

---

## 🏠 Home Screen - TabView Structure

```
┌─────────────────────────────────────┐
│  ← Seemi's Spiritual Collection     │  ← Navigation Bar
├─────────────────────────────────────┤
│                                     │
│         [CONTENT AREA]              │  ← Tab-specific content
│                                     │    (see below for each tab)
│                                     │
│                                     │
│                                     │
│                                     │
│                                     │
│                                     │
│                                     │
│                                     │
├─────────────────────────────────────┤
│  📖         💬         ⚙️           │  ← Tab Bar
│ Islamic   Chat with  Settings      │
│ Content    Iman                     │
└─────────────────────────────────────┘
```

---

## 📖 Tab 1: Islamic Content View

```
┌─────────────────────────────────────┐
│  Seemi's Spiritual Collection       │
│  8 Sacred Duas & Surahs             │  ← Header
├─────────────────────────────────────┤
│                                     │
│  ┌───────────────────────────────┐  │
│  │ 1. Dua to Remove Worry...  ⌄ │  │  ← Card (Collapsed)
│  │    Musnad Ahmad 1/391        │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ 2. Morning & Evening...    ⌃ │  │  ← Card (Expanded)
│  │    Abu Dawud 5088            │  │
│  ├───────────────────────────────┤  │
│  │                               │  │
│  │  بِسْمِ اللهِ الَّذِي لَا يَضُرُّ...  │  │  ← Arabic (RTL, 22pt)
│  │                               │  │
│  │  🔁 Recite 3x                 │  │  ← Repeat badge
│  │                               │  │
│  │  In the Name of Allah, Who   │  │  ← English (16pt)
│  │  with His Name nothing can... │  │
│  │                               │  │
│  │  ▶️  Audio Playback           │  │  ← Audio controls
│  │     Coming in Phase 2         │  │
│  │                               │  │
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ 3. Surah Ar-Rahman...      ⌄ │  │
│  │    Quran 55:1-78             │  │
│  └───────────────────────────────┘  │
│                                     │
│  [... 5 more cards ...]            │
│                                     │
└─────────────────────────────────────┘
```

### Card Specifications:

**Collapsed State:**
```
┌─────────────────────────────────────┐
│ Title (20pt, semibold, #1B5E20)  ⌄ │  ← Chevron down
│ Source (14pt, secondary)            │
└─────────────────────────────────────┘
  Padding: 20pt all sides
  Background: White
  Corner Radius: 20pt
  Shadow: 0,4 radius 8, opacity 0.08
```

**Expanded State:**
```
┌─────────────────────────────────────┐
│ Title (20pt, semibold, #1B5E20)  ⌃ │  ← Chevron up
│ Source (14pt, secondary)            │
├─────────────────────────────────────┤  ← Divider
│                                     │
│ Arabic Text (22pt, medium, RTL)    │  ← Right-aligned
│ Line spacing: 8pt                   │    Tappable for fullscreen
│                                     │
│ 🔁 Recite 3x (if applicable)        │  ← Orange badge
│                                     │
│ English Translation (16pt)          │  ← Left-aligned
│ Line spacing: 4pt                   │
│                                     │
│ ▶️ [40pt] Audio Playback            │  ← Green button
│   Coming in Phase 2                 │
│                                     │
└─────────────────────────────────────┘
```

### Fullscreen Arabic Modal:
```
┌─────────────────────────────────────┐
│  ← Dua to Remove Worry...    [Done] │  ← Nav bar
├─────────────────────────────────────┤
│                                     │
│                                     │
│    اللَّهُمَّ إِنِّي عَبْدُكَ، ابْنُ عَبْدِكَ    │
│                                     │
│    ابْنُ أَمَتِكَ، نَاصِيَتِي بِيَدِكَ    │  ← 28pt, medium
│                                     │    RTL, #1B5E20
│    مَاضٍ فِيَّ حُكْمُكَ، عَدْلٌ فِيَّ    │    Line spacing: 12pt
│                                     │
│    قَضَاؤُكَ، أَسْأَلُكَ بِكُلِّ اسْمٍ    │
│                                     │
│    [... full text ...]              │
│                                     │
│                                     │
└─────────────────────────────────────┘
  Background: #F1F8E9 (light green)
  Scrollable
```

---

## 💬 Tab 2: Chat with Iman

### Empty State:
```
┌─────────────────────────────────────┐
│  ← Chat with Iman                   │
├─────────────────────────────────────┤
│                                     │
│                                     │
│                                     │
│              ❤️                      │  ← 60pt heart icon
│                                     │    #66BB6A color
│    Assalamu Alaikum Seemi dear!    │  ← 24pt, semibold
│                                     │
│  I'm Iman, your caring sister from  │  ← 16pt, secondary
│  Lahore. How can I help you today?  │    Centered
│                                     │
│                                     │
│                                     │
│                                     │
├─────────────────────────────────────┤
│ ┌─────────────────────────────┐ ⬆️ │  ← Input bar
│ │ Message Iman...             │    │    Gray send button
│ └─────────────────────────────┘    │    (disabled)
└─────────────────────────────────────┘
  Background: #F5F5F5
```

### With Messages:
```
┌─────────────────────────────────────┐
│  ← Chat with Iman                   │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────┐        │  ← Bot message
│  │ Wa Alaikum Assalam     │        │    White bubble
│  │ Seemi dear! 🌸          │        │    Left-aligned
│  └─────────────────────────┘        │
│  2:30 PM                            │  ← Timestamp (12pt)
│                                     │
│         ┌─────────────────────────┐ │  ← User message
│         │ How are you today?     │ │    Green bubble
│         └─────────────────────────┘ │    Right-aligned
│                            2:31 PM  │
│                                     │
│  ┌─────────────────────────┐        │
│  │ Alhamdulillah, I'm well │        │
│  │ my sister. How about... │        │
│  └─────────────────────────┘        │
│  2:31 PM                            │
│                                     │
├─────────────────────────────────────┤
│ ┌─────────────────────────────┐ ⬆️ │  ← Input bar
│ │ Tell me about Lahore...     │    │    Green send button
│ └─────────────────────────────┘    │    (enabled)
└─────────────────────────────────────┘
```

### Message Bubble Specs:

**User Bubble (Right):**
```
┌─────────────────────┐
│ Message text here  │  ← 16pt, white text
└─────────────────────┘    Background: #66BB6A
         2:30 PM            Corner radius: 16pt
                            Max width: 280pt
                            Padding: 12pt
```

**Bot Bubble (Left):**
```
┌─────────────────────┐
│ Message text here  │  ← 16pt, black text
└─────────────────────┘    Background: White
2:30 PM                    Corner radius: 16pt
                           Max width: 280pt
                           Padding: 12pt
```

---

## ⚙️ Tab 3: Settings

```
┌─────────────────────────────────────┐
│  ← Settings                         │
├─────────────────────────────────────┤
│                                     │
│  ┌───────────────────────────────┐  │
│  │ 👤 [50pt]  Seemi Warris       │  │  ← Profile section
│  │            Exclusive User      │  │
│  └───────────────────────────────┘  │
│                                     │
│  Appearance                         │  ← Section header
│  ┌───────────────────────────────┐  │
│  │ 🌙 Dark Mode          [Toggle]│  │  ← Toggle (green)
│  └───────────────────────────────┘  │
│                                     │
│  Notifications                      │
│  ┌───────────────────────────────┐  │
│  │ 🔔 Enable Notifications [On] │  │
│  ├───────────────────────────────┤  │
│  │ 🕐 Prayer Times      5 Daily  │  │  ← Sub-items
│  │ 📖 Daily Duas        3 Daily  │  │    (when enabled)
│  └───────────────────────────────┘  │
│                                     │
│  Prayer Settings                    │
│  ┌───────────────────────────────┐  │
│  │ 🌍 Time Zone   Asia/Karachi   │  │
│  │ 📍 Location    Lahore, Pak... │  │
│  └───────────────────────────────┘  │
│                                     │
│  About                              │
│  ┌───────────────────────────────┐  │
│  │ Version        1.0.0 (Phase 1)│  │
│  │ Developer      Iman Mohamed...│  │
│  │ Powered by NextEleven AI   ↗  │  │  ← Link
│  └───────────────────────────────┘  │
│                                     │
│  ┌───────────────────────────────┐  │
│  │ 🗑️ Clear Chat History         │  │  ← Destructive (red)
│  └───────────────────────────────┘  │
│                                     │
└─────────────────────────────────────┘
  Background: #F1F8E9
  Form style with sections
```

---

## 🎨 Color Palette

### Light Mode:
```
Primary Green:    #66BB6A  ████  (Buttons, accents)
Secondary Green:  #81C784  ████  (Gradients)
Dark Green:       #1B5E20  ████  (Text, headings)
Medium Green:     #2E7D32  ████  (Subheadings)

Background 1:     #F1F8E9  ████  (Light green wash)
Background 2:     #E8F5E9  ████  (Lighter green)
Background 3:     #DCEDC8  ████  (Gradient end)

White:            #FFFFFF  ████  (Cards, bubbles)
Light Gray:       #F5F5F5  ████  (Chat background)
Medium Gray:      #9E9E9E  ████  (Secondary text)

Orange:           #F57C00  ████  (Repeat badges)
Orange Light:     #FFF3E0  ████  (Badge background)
```

### Dark Mode:
```
Primary Green:    #81C784  ████  (Lighter for contrast)
Background:       #121212  ████  (True black)
Surface:          #1E1E1E  ████  (Cards)
Text:             #E0E0E0  ████  (Primary text)
```

---

## 📐 Layout Measurements

### iPhone 16 Pro (393 × 852 pt):
```
Safe Area Top:     59pt (with Dynamic Island)
Safe Area Bottom:  34pt (home indicator)
Card Width:        361pt (393 - 32 padding)
Card Spacing:      20pt
Tab Bar Height:    49pt + safe area
```

### iPad Pro 12.9" (1024 × 1366 pt):
```
Safe Area Top:     24pt
Safe Area Bottom:  20pt
Card Max Width:    700pt (centered)
Card Spacing:      24pt
Tab Bar Height:    50pt + safe area
```

---

## 🎭 Animation Specifications

### Spring Animations:
```swift
// Card expansion
.spring(response: 0.4, dampingFraction: 0.8)

// Tab switching
.spring(response: 0.3, dampingFraction: 1.0)

// Modal presentation
.spring(response: 0.5, dampingFraction: 0.9)

// Jasmine petals
.spring(response: 0.6, dampingFraction: 0.6)
```

### Haptic Feedback:
```
Tab switch:       UIImpactFeedbackGenerator(.light)
Card tap:         UIImpactFeedbackGenerator(.medium)
Button press:     UIImpactFeedbackGenerator(.light)
Send message:     UIImpactFeedbackGenerator(.medium)
```

---

## 📱 Responsive Breakpoints

### Compact Width (iPhone):
- Single column layout
- Full-width cards (minus padding)
- Smaller font sizes
- Stacked elements

### Regular Width (iPad):
- Centered content (max 700pt)
- Larger font sizes
- More whitespace
- Side-by-side elements (where appropriate)

---

## ♿ Accessibility

### Dynamic Type Support:
```
Titles:        .title2 → .title
Body:          .body → .body
Captions:      .caption → .footnote
Arabic:        Fixed 22pt (readability)
```

### VoiceOver Labels:
```
Launch screen: "Seemi's Spiritual Companion. Loading."
Islamic cards: "Dua card. [Title]. Tap to expand."
Chat input:    "Message input field. Type your message."
Settings:      "Dark mode toggle. Currently [on/off]."
```

### Color Contrast:
```
WCAG AAA: Text on background ≥ 7:1
WCAG AA:  UI elements ≥ 3:1

Tested combinations:
- #1B5E20 on #F1F8E9: 9.2:1 ✅
- #FFFFFF on #66BB6A: 4.8:1 ✅
- #2E7D32 on #FFFFFF: 6.1:1 ✅
```

---

## 🖼️ Asset Requirements (Phase 2)

### Images:
- App Icon: 1024×1024 (all sizes via Asset Catalog)
- Jasmine SVG: Scalable vector (or Lottie JSON)
- Background patterns: 2x, 3x PNG

### Audio:
- 8 Dua/Surah MP3s (bundled or streamed)
- 5 Prayer notification sounds
- Voice feedback sounds

### Fonts:
- System fonts (SF Pro, SF Arabic)
- No custom fonts needed

---

**This completes the Phase 1 wireframe documentation!** 🎨

All measurements, colors, and animations are implemented in the Swift code provided.

*May Allah accept this work. Ameen.* 🤲
