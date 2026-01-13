# Text Color Fixes - January 13, 2026

## Issue
White text was not readable on physical devices due to white/light backgrounds.

## Fixes Applied

### 1. ImanChatView.swift
- Changed background from `Color(hex: "#F5F5F5")` to `Color(UIColor.systemGroupedBackground)` - adapts to light/dark mode
- Added `.foregroundStyle(.primary)` to "Assalamu Alaikum Seemi" text
- Changed chat bubble backgrounds from `Color.white` to `Color(UIColor.secondarySystemGroupedBackground)`
- Changed text field background from `Color.white` to `Color(UIColor.secondarySystemGroupedBackground)`
- Changed typing indicator background from `Color.white` to `Color(UIColor.secondarySystemGroupedBackground)`

### 2. DuaCardView.swift
- Changed card backgrounds from `Color.white` to `Color(UIColor.secondarySystemGroupedBackground)`
- This ensures proper contrast in both light and dark modes

### 3. Benefits of Using UIColor System Colors
- `systemGroupedBackground` - Automatically adapts to light/dark mode
- `secondarySystemGroupedBackground` - Provides proper contrast for content cards
- `.primary` and `.secondary` text colors - Automatically adjust for readability

## Testing
- Build succeeded with no errors
- Archive created successfully
- All text should now be readable on physical devices in both light and dark modes

## Color Scheme
The app uses:
- Green accent: `#66BB6A` (Jasmine green)
- Backgrounds: System-provided colors that adapt to appearance
- Text: `.primary` and `.secondary` for automatic contrast
