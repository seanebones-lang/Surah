# Seemi's Spiritual Companion

A native iOS/iPadOS application providing Islamic spiritual content and AI companionship.

## Features

### Islamic Content
- 8 authentic Duas and Surahs with Arabic text and English translations
- Audio playback for select items
- Offline support for bundled audio
- RTL Arabic text rendering

### AI Chat
- Conversational AI powered by xAI Grok
- Urdu, English, and Lahori dialect support
- Voice input and output capabilities
- Persistent conversation history

### Notifications
- Location-based prayer time reminders (5 daily)
- Daily Dua reminders (3 daily)
- Customizable notification settings

### Additional Features
- Dark mode support
- Usage statistics tracking
- Islamic calendar (Hijri dates)
- Universal app (iPhone and iPad)

## Technical Stack

- **Language:** Swift 6.0
- **Framework:** SwiftUI 6
- **Persistence:** SwiftData
- **Networking:** Alamofire
- **AI:** xAI Grok API
- **Minimum iOS:** 18.0

## Setup

1. Open `SeemiSpiritualCompanion.xcodeproj` in Xcode 16+
2. Build and run on iPhone or iPad simulator
3. Configure xAI API key in Settings → AI Settings
4. Grant permissions for location, notifications, and speech recognition

## Privacy

- All data stored locally using SwiftData
- API key secured in iOS Keychain
- No analytics or tracking
- Optional location services for prayer times

## License

Exclusive application for Seemi Warris. All rights reserved.
