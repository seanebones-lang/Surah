# Phase 1 Testing Checklist ✅

**Seemi's Spiritual Companion - Phase 1 Verification**

Test on: iPhone 16 Pro & iPad Pro simulators (iOS 18+)

---

## 🚀 Launch Screen Tests

### Visual Tests:
- [ ] Jasmine flower appears centered
- [ ] 8 white petals bloom in sequence
- [ ] Yellow center appears last
- [ ] Background gradient (light to dark green) displays correctly
- [ ] "Assalamu Alaikum" text is visible and centered
- [ ] "Seemi" name is bold and prominent
- [ ] Time-based greeting appears below name

### Functional Tests:
- [ ] Launch at 6 AM - 12 PM: Shows "Good Morning"
- [ ] Launch at 12 PM - 5 PM: Shows "Good Afternoon"
- [ ] Launch at 5 PM - 9 PM: Shows "Good Evening"
- [ ] Launch at 9 PM - 6 AM: Shows "Good Night"
- [ ] Bismillah text appears at bottom
- [ ] Auto-transitions to Home after exactly 3 seconds
- [ ] Transition animation is smooth (fade out)

### Animation Tests:
- [ ] Petals bloom with staggered timing (0.08s delay each)
- [ ] Spring animation feels natural (not too bouncy)
- [ ] Text fades in smoothly
- [ ] No frame drops or stuttering

---

## 🏠 Home TabView Tests

### Navigation Tests:
- [ ] 3 tabs are visible at bottom
- [ ] Tab 1: "Islamic Content" with book icon
- [ ] Tab 2: "Chat with Iman" with message icon
- [ ] Tab 3: "Settings" with gear icon
- [ ] Tapping tabs switches views instantly
- [ ] Selected tab is highlighted in green (#66BB6A)
- [ ] Haptic feedback occurs on tab switch

### Layout Tests (iPhone):
- [ ] Tabs fill screen width evenly
- [ ] Safe area respected (no notch overlap)
- [ ] Portrait orientation works
- [ ] Landscape orientation works

### Layout Tests (iPad):
- [ ] Tabs display correctly in portrait
- [ ] Tabs display correctly in landscape
- [ ] Content scales appropriately
- [ ] No stretched or compressed elements

---

## 📖 Islamic Content Tab Tests

### Card Display Tests:
- [ ] Exactly 8 cards are visible
- [ ] Cards are in correct order:
  1. Dua to Remove Worry & Sorrow
  2. Morning & Evening Protection Dua
  3. Surah Ar-Rahman
  4. Dua for Tension & Depression
  5. Wazifa for Protection
  6. Dua for Healing
  7. Dua Against Evil Eye
  8. Manzil Dua
- [ ] Each card has white background
- [ ] Cards have subtle shadow
- [ ] 20pt padding between cards
- [ ] Scroll is smooth

### Card Header Tests:
- [ ] Title is visible and readable (20pt, semibold)
- [ ] Source is below title (14pt, secondary color)
- [ ] Chevron icon appears on right
- [ ] Chevron is circle.down when collapsed
- [ ] Chevron is circle.up when expanded

### Card Expansion Tests:
- [ ] Tap card header to expand
- [ ] Tap again to collapse
- [ ] Only one card can be expanded at a time
- [ ] Expansion animation is smooth (spring)
- [ ] Haptic feedback on tap (medium impact)

### Arabic Text Tests:
- [ ] Arabic text is right-aligned (RTL)
- [ ] Font size is 22pt, medium weight
- [ ] Line spacing is 8pt
- [ ] Text is dark green (#1B5E20)
- [ ] Tap Arabic text to open fullscreen modal
- [ ] Modal shows larger Arabic text (28pt)
- [ ] Modal has "Done" button
- [ ] Modal dismisses correctly

### English Translation Tests:
- [ ] Translation appears below Arabic
- [ ] Font size is 16pt, regular weight
- [ ] Left-aligned (LTR)
- [ ] Line spacing is 4pt
- [ ] Text is readable

### Repeat Count Tests:
- [ ] Item #2 (Protection Dua) shows "Recite 3x" badge
- [ ] Item #5 (Wazifa) shows "Recite 3x" badge
- [ ] Badge is orange (#F57C00) on light orange background
- [ ] Repeat icon appears next to text

### Audio Controls Tests (Placeholder):
- [ ] Play button appears (circle.fill icon)
- [ ] Button size is 40pt
- [ ] Button color is green (#66BB6A)
- [ ] Tap changes to pause icon
- [ ] "Coming in Phase 2" text visible

### Source Attribution Tests:
- [ ] Item #1: "Musnad Ahmad 1/391"
- [ ] Item #2: "Abu Dawud 5088, At-Tirmidhi 3388"
- [ ] Item #3: "Quran 55:1-78"
- [ ] Item #4: "Quran 65:3 (At-Talaq)"
- [ ] Item #5: "Abu Dawud 5088"
- [ ] Item #6: "Quran 17:82 (Al-Isra)"
- [ ] Item #7: "Quran 113 (Al-Falaq)"
- [ ] Item #8: "Compiled from Quran"

---

## 💬 Chat with Iman Tab Tests

### Initial State Tests:
- [ ] Welcome screen appears when no messages
- [ ] Heart icon (60pt) is centered
- [ ] "Assalamu Alaikum Seemi dear!" heading visible
- [ ] Subtitle text: "I'm Iman, your caring sister from Lahore..."
- [ ] Background is light gray (#F5F5F5)

### Input Bar Tests:
- [ ] Text field is at bottom
- [ ] Placeholder: "Message Iman..."
- [ ] Text field expands vertically (1-5 lines)
- [ ] Send button (arrow.up.circle.fill) on right
- [ ] Send button is gray when text is empty
- [ ] Send button is green (#66BB6A) when text exists
- [ ] Send button disabled when empty

### Message Sending Tests:
- [ ] Type message and tap send
- [ ] Message appears as user bubble (right-aligned)
- [ ] User bubble is green background, white text
- [ ] Text field clears after sending
- [ ] Timestamp appears below bubble (12pt, secondary)
- [ ] Bot response appears after 1 second
- [ ] Bot bubble is white background, black text
- [ ] Bot bubble is left-aligned

### Message Display Tests:
- [ ] User messages align right
- [ ] Bot messages align left
- [ ] Bubbles have 16pt corner radius
- [ ] Max bubble width is 280pt
- [ ] Bubbles have 12pt padding
- [ ] Scroll to bottom on new message

### Placeholder Response Test:
- [ ] Bot says: "Wa Alaikum Assalam Seemi dear! Full AI integration coming in Phase 2 insha'Allah. 🌸"

---

## ⚙️ Settings Tab Tests

### Profile Section Tests:
- [ ] Profile icon (person.circle.fill, 50pt) visible
- [ ] Name "Seemi Warris" is bold (22pt)
- [ ] Subtitle "Exclusive User" appears (14pt, secondary)

### Appearance Section Tests:
- [ ] "Dark Mode" toggle present
- [ ] Toggle has moon.fill icon
- [ ] Toggle color is green (#66BB6A) when on
- [ ] Switching toggle changes app theme instantly
- [ ] All views respect dark mode

### Notifications Section Tests:
- [ ] "Enable Notifications" toggle present
- [ ] Toggle has bell.fill icon
- [ ] When enabled, shows "Prayer Times: 5 Daily"
- [ ] When enabled, shows "Daily Duas: 3 Daily"
- [ ] When disabled, sub-items hidden

### Prayer Settings Section Tests:
- [ ] "Time Zone" row shows "Asia/Karachi"
- [ ] "Location" row shows "Lahore, Pakistan"
- [ ] Globe icon for time zone
- [ ] Location icon for location

### About Section Tests:
- [ ] Version shows "1.0.0 (Phase 1)"
- [ ] Developer shows "Iman Mohamed Aziz"
- [ ] "Powered by NextEleven AI" is a tappable link
- [ ] Link has arrow.up.right icon

### Clear History Tests:
- [ ] "Clear Chat History" button is red (destructive)
- [ ] Button has trash icon
- [ ] Button appears in separate section

---

## 🎨 Theme & Styling Tests

### Color Consistency:
- [ ] Primary green (#66BB6A) used for accents
- [ ] Background gradients use light greens
- [ ] Text uses dark green (#1B5E20, #2E7D32)
- [ ] White cards have subtle shadows

### Typography:
- [ ] Arabic text uses system font (not custom)
- [ ] English uses SF Pro
- [ ] Font sizes are consistent across views
- [ ] Line spacing is comfortable

### Animations:
- [ ] All transitions use spring animations
- [ ] No jarring or instant changes
- [ ] Haptic feedback on:
  - Tab switches
  - Card taps
  - Button presses

### Dark Mode:
- [ ] Toggle in Settings works
- [ ] Launch screen adapts
- [ ] Islamic cards adapt
- [ ] Chat bubbles adapt
- [ ] Settings adapt
- [ ] Text remains readable
- [ ] Contrast is sufficient

---

## 📱 Device-Specific Tests

### iPhone 16 Pro:
- [ ] Launch screen fills screen
- [ ] No safe area violations
- [ ] Tabs don't overlap home indicator
- [ ] Text is readable at default size
- [ ] Landscape mode works

### iPad Pro 12.9":
- [ ] Launch screen scales appropriately
- [ ] Cards use available width (not stretched)
- [ ] Chat bubbles don't span full width
- [ ] Settings form is readable
- [ ] Both orientations work

---

## 🐛 Bug & Edge Case Tests

### Memory Tests:
- [ ] No memory leaks after 10 tab switches
- [ ] Scrolling 8 cards is smooth
- [ ] Expanding/collapsing cards doesn't lag

### Text Edge Cases:
- [ ] Very long message in chat wraps correctly
- [ ] Arabic text with diacritics displays correctly
- [ ] Empty message can't be sent

### State Persistence:
- [ ] Dark mode preference persists (Phase 2: UserDefaults)
- [ ] Selected tab resets on app restart (expected)
- [ ] Chat messages persist (SwiftData)

### Error Handling:
- [ ] No crashes on rapid tab switching
- [ ] No crashes on rapid card tapping
- [ ] No crashes on app backgrounding

---

## ✅ Success Criteria

**Phase 1 is complete when ALL items above are checked.**

Minimum requirements:
- ✅ Launch screen animates correctly
- ✅ All 3 tabs are functional
- ✅ 8 Islamic cards display with Arabic RTL
- ✅ Chat UI accepts and displays messages
- ✅ Settings toggles work
- ✅ Dark mode functions
- ✅ No crashes or build errors

---

## 📊 Performance Benchmarks

Target metrics:
- Launch to Home: < 3.5 seconds
- Tab switch: < 100ms
- Card expand: < 300ms
- Message send: < 50ms
- Dark mode toggle: < 100ms

---

## 🎯 Next Steps After Phase 1

Once all tests pass:
1. Take screenshots for documentation
2. Note any UI refinements needed
3. Prepare for Phase 2:
   - Audio playback implementation
   - NextEleven API integration
   - Notification setup
   - Voice features

---

**Reply "Phase 2" when Phase 1 testing is complete!** 🚀

*May Allah make this testing process smooth and successful. Ameen.* 🤲
