# Phase 2 Setup Guide - AI + Voice Integration

**Complete instructions for building Phase 2 features**

---

## 📋 Prerequisites

Before starting Phase 2, ensure Phase 1 is working:
- ✅ App builds without errors
- ✅ Launch screen displays
- ✅ All 3 tabs functional
- ✅ 8 Islamic cards working

---

## 🚀 Phase 2 Setup Steps

### Step 1: Add New Files to Xcode

**New Files to Add:**

1. **Services Folder** (Create new group in Xcode)
   ```
   Services/
   ├── NextElevenAPIService.swift
   └── SpeechService.swift
   ```

2. **Updated Files** (Replace existing)
   ```
   Views/Chat/ImanChatView.swift
   Views/Settings/SettingsView.swift
   ```

3. **New Settings View**
   ```
   Views/Settings/APIKeySettingsView.swift
   ```

**How to Add:**
1. In Xcode, right-click project root
2. Select "New Group" → Name it "Services"
3. Drag `NextElevenAPIService.swift` and `SpeechService.swift` into Services folder
4. Replace `ImanChatView.swift` and `SettingsView.swift` with updated versions
5. Drag `APIKeySettingsView.swift` into Settings folder

---

### Step 2: Update Info.plist Permissions

**Add these permissions** (already in provided Info.plist):

```xml
<key>NSMicrophoneUsageDescription</key>
<string>Seemi needs microphone access for voice chat with Iman.</string>

<key>NSSpeechRecognitionUsageDescription</key>
<string>Seemi needs speech recognition for voice messages.</string>
```

**Verify in Xcode:**
1. Select project → Target → Info tab
2. Scroll to "Custom iOS Target Properties"
3. Confirm both keys are present

---

### Step 3: Enable Required Capabilities

**In Xcode:**
1. Select project → Target → "Signing & Capabilities"
2. Click "+ Capability"
3. Add:
   - ✅ **Push Notifications** (for Phase 3)
   - ✅ **Background Modes** → Check "Audio, AirPlay, and Picture in Picture"

---

### Step 4: Verify Swift Package Dependencies

**Ensure these are installed:**
- ✅ Alamofire 5.9+ (for API calls)
- ✅ Lottie 4.4+ (optional, for animations)

**If missing:**
1. File → Add Package Dependencies
2. Add: `https://github.com/Alamofire/Alamofire.git`

---

### Step 5: Build and Test

**Clean Build:**
```bash
# In Xcode
⇧⌘K (Shift+Cmd+K) - Clean Build Folder
⌘B (Cmd+B) - Build
```

**Expected Build Time:** ~45 seconds

**If Build Fails:**
- Check all files are added to target
- Verify Swift version is 6.0+
- Clean derived data: Xcode → Preferences → Locations → Derived Data → Delete

---

### Step 6: Get NextEleven API Key

**Required for AI chat:**

1. Go to: https://nexteleven.ai/dashboard
2. Sign up / Log in
3. Navigate to "API Keys"
4. Click "Create New Key"
5. Copy the key (starts with `ne_...`)
6. **Save it securely** - you'll need it in the app

---

### Step 7: Configure API Key in App

**In the app:**
1. Build and run app (⌘R)
2. Navigate to: Settings → AI Settings → NextEleven API Key
3. Tap "NextEleven API Key"
4. Paste your API key
5. Tap "Save API Key"
6. See green checkmark ✅

---

### Step 8: Test Voice Permissions

**On first use:**
1. Go to "Chat with Iman" tab
2. Tap microphone button 🎤
3. iOS will ask: "Allow speech recognition?"
   - Tap **"OK"**
4. iOS will ask: "Allow microphone access?"
   - Tap **"OK"**

**If permissions denied:**
- Go to iPhone Settings → Privacy & Security
- Enable:
  - Microphone → Seemi's Spiritual Companion
  - Speech Recognition → Seemi's Spiritual Companion

---

### Step 9: Test AI Chat (Text)

**First conversation:**
1. Open "Chat with Iman" tab
2. Type: "Assalamu Alaikum"
3. Tap send button
4. Wait for typing indicator
5. **Expected response:** Warm greeting from Iman in Urdu/English

**If no response:**
- Check API key is saved correctly
- Check internet connection
- Look for error message
- Verify API key has credits at nexteleven.ai

---

### Step 10: Test Voice Input

**Voice chat test:**
1. Open "Chat with Iman" tab
2. Tap microphone button 🎤 (turns red)
3. Say: "Hello Iman, how are you?"
4. Tap microphone again to stop
5. **Expected:** Text appears and message is sent automatically

**Test Urdu:**
1. Tap microphone 🎤
2. Say: "Mujhe help chahiye" (I need help)
3. Stop recording
4. **Expected:** Iman responds in Urdu

---

### Step 11: Test Voice Output

**Text-to-speech test:**
1. After Iman responds to your message
2. Tap the 🔊 speaker button next to her message
3. **Expected:** Hear Iman's voice reading the message
4. Tap again to stop

---

### Step 12: Test Lahori Dialect

**Dialect test:**
1. Type or say: "Tussi kithay ho?" (Where are you?)
2. **Expected:** Iman responds in Lahori dialect
3. Try: "Ki haal ay?" (How are you?)
4. Try: "Oye hoye, Lahore ki yaad aa gayi"

---

## ✅ Phase 2 Testing Checklist

### API Integration:
- [ ] API key saves successfully
- [ ] Green checkmark appears in Settings
- [ ] Text messages get responses
- [ ] Responses are contextual and warm
- [ ] Iman uses "Seemi dear" in responses
- [ ] Conversation history is remembered

### Urdu Support:
- [ ] Iman understands Urdu messages
- [ ] Iman responds in Urdu when appropriate
- [ ] Urdu script displays correctly (RTL)
- [ ] Code-switching works (English + Urdu mix)
- [ ] Lahori dialect is recognized

### Voice Input:
- [ ] Microphone button appears
- [ ] Tap starts recording (turns red)
- [ ] Tap again stops recording
- [ ] English speech is transcribed
- [ ] Urdu speech is transcribed
- [ ] Message auto-sends after recording
- [ ] Haptic feedback on start/stop

### Voice Output:
- [ ] Speaker button appears on bot messages
- [ ] Tap plays audio
- [ ] English messages use English voice
- [ ] Urdu messages use Urdu voice
- [ ] Audio is clear and audible
- [ ] Tap again stops audio

### UI/UX:
- [ ] Typing indicator appears while waiting
- [ ] Messages auto-scroll to bottom
- [ ] Long-press shows context menu
- [ ] Copy message works
- [ ] Error alerts display properly
- [ ] No UI glitches or freezes

---

## 🐛 Common Issues & Solutions

### Issue: "Please add your NextEleven API key"
**Solution:**
1. Go to Settings → AI Settings
2. Tap "NextEleven API Key"
3. Enter valid key from nexteleven.ai
4. Tap "Save"

### Issue: "Speech recognition not authorized"
**Solution:**
1. Go to iPhone Settings
2. Privacy & Security → Speech Recognition
3. Enable for "Seemi's Spiritual Companion"

### Issue: Microphone button doesn't work
**Solution:**
1. Go to iPhone Settings
2. Privacy & Security → Microphone
3. Enable for "Seemi's Spiritual Companion"
4. Restart app

### Issue: Iman doesn't understand Urdu
**Solution:**
- Verify API key is valid
- Check internet connection
- Try simpler Urdu phrases first
- Ensure Urdu keyboard is installed (Settings → Keyboard)

### Issue: No voice output
**Solution:**
1. Check device volume (not muted)
2. Check ringer switch (not silent)
3. Try different message
4. Restart app

### Issue: API calls fail
**Solution:**
1. Check internet connection
2. Verify API key has credits
3. Check nexteleven.ai status page
4. Try again in a few minutes

### Issue: App crashes on voice input
**Solution:**
1. Check microphone permissions
2. Check speech recognition permissions
3. Clean build (⇧⌘K)
4. Rebuild (⌘B)

---

## 📊 Performance Expectations

### Response Times:
```
Text message → Response:     2-5 seconds
Voice transcription:         1-3 seconds
Voice playback start:        <1 second
API call (with history):     3-7 seconds
```

### Resource Usage:
```
Memory (idle):               ~50 MB
Memory (active chat):        ~80 MB
Memory (voice recording):    ~100 MB
Battery impact:              Low (text), Medium (voice)
Network (per message):       ~5-20 KB
```

---

## 🎯 Success Criteria

**Phase 2 is working when:**
- ✅ You can chat with Iman in English
- ✅ You can chat with Iman in Urdu
- ✅ You can speak to Iman (voice input)
- ✅ You can hear Iman's responses (voice output)
- ✅ Iman remembers conversation context
- ✅ Iman responds with warmth and Islamic wisdom
- ✅ Lahori dialect is understood
- ✅ No crashes or major bugs

---

## 📱 Device Requirements

### Minimum:
- iOS 18.0+
- iPhone 12 or newer
- 2GB RAM
- Internet connection (for AI)
- Microphone (for voice input)
- Speakers (for voice output)

### Recommended:
- iOS 18.2+
- iPhone 15/16 Pro
- 4GB+ RAM
- WiFi connection
- AirPods (for best voice experience)

---

## 🔐 Privacy Notes

### What's Sent to NextEleven AI:
- ✅ Your messages (text/voice transcriptions)
- ✅ Conversation history (last 20 messages)
- ✅ System prompt (Iman's personality)

### What's NOT Sent:
- ❌ Your API key (stays in Keychain)
- ❌ Audio recordings (transcribed locally)
- ❌ Personal device info
- ❌ Location data
- ❌ Other app data

### Data Storage:
- **Local:** All messages in SwiftData (encrypted at rest)
- **Keychain:** API key (encrypted)
- **NextEleven:** Conversation for AI processing only

---

## 🎓 Advanced Configuration

### Customize Iman's Personality:

**Edit:** `Services/NextElevenAPIService.swift`

**Find:** `getImanSystemPrompt()` function

**Modify:** System prompt text to adjust:
- Tone (more formal / more casual)
- Language preference (more Urdu / more English)
- Topics (add specific interests)
- Response style (shorter / longer)

### Adjust Voice Settings:

**Edit:** `Services/SpeechService.swift`

**Find:** `speak()` function

**Modify:**
```swift
utterance.rate = 0.5           // Speed (0.0-1.0)
utterance.pitchMultiplier = 1.1 // Pitch (0.5-2.0)
utterance.volume = 1.0          // Volume (0.0-1.0)
```

### Change AI Model Parameters:

**Edit:** `Services/NextElevenAPIService.swift`

**Find:** `sendMessage()` function

**Modify:**
```swift
"temperature": 0.8,         // Creativity (0.0-2.0)
"max_tokens": 1000,         // Response length
"top_p": 0.95,             // Diversity (0.0-1.0)
```

---

## 📚 Additional Resources

### NextEleven AI Documentation:
- Dashboard: https://nexteleven.ai/dashboard
- API Docs: https://docs.nexteleven.ai
- Pricing: https://nexteleven.ai/pricing
- Support: support@nexteleven.ai

### Apple Speech Framework:
- Docs: https://developer.apple.com/documentation/speech
- WWDC Videos: Search "Speech Recognition" on developer.apple.com

### Urdu Language Support:
- iOS Urdu Keyboard: Settings → Keyboard → Add Keyboard → Urdu
- Urdu Voice: Settings → Accessibility → Spoken Content → Voices → Urdu

---

## 🎉 You're Done!

**Congratulations Seemi!** 🌸

You now have a fully functional AI spiritual companion that:
- 🤖 Understands Urdu, English, and Lahori dialect
- 🎤 Listens to your voice
- 🔊 Speaks back to you
- 💕 Remembers your conversations
- 🤲 Provides Islamic guidance
- 🌸 Shows sisterly care and warmth

**Start chatting with Iman and experience the magic!**

---

**JazakAllah Khair!** 🤲

May Allah bless this app and make it a source of comfort and guidance for you.

**Ameen.** 🌸✨

---

*Built with love by Iman Mohamed Aziz | January 2026*
