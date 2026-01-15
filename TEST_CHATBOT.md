# Chatbot E2E Test Procedure

## Manual Testing Steps

1. **Launch App in Simulator**
   ```bash
   xcodebuild -project SeemiSpiritualCompanion.xcodeproj \
     -scheme SeemiSpiritualCompanion \
     -sdk iphonesimulator \
     -destination 'platform=iOS Simulator,id=46E71B54-6AFE-446D-A4EC-19487DA2BD0C' \
     run
   ```

2. **Configure API Key**
   - Navigate to: Settings → AI Settings
   - Enter valid xAI API key
   - Save key

3. **Test Chatbot**
   - Navigate to Chat tab
   - Send message: "Hello" or "Assalamu Alaikum"
   - Verify response appears
   - Check console for errors

4. **Check Console Logs**
   - Look for: "Initiating API request to https://api.x.ai/v1/chat/completions with model: grok-4-1-fast-reasoning"
   - Verify model name is correct
   - Check for API errors (401, 404, 400, 500)
   - Verify response received

## Expected Behavior

✅ **Success Indicators:**
- API request shows correct model: `grok-4-1-fast-reasoning`
- HTTP 200 response
- Chat message appears in UI
- No error messages in console

❌ **Failure Indicators:**
- HTTP 401: Invalid/missing API key
- HTTP 404: Wrong model name or endpoint
- HTTP 400: Invalid request format
- HTTP 500: Server error (retry should handle)
- Timeout errors
- Empty response errors

## Current Configuration

- **Model:** `grok-4-1-fast-reasoning`
- **Endpoint:** `https://api.x.ai/v1/chat/completions`
- **API Key:** Must be configured in Settings
- **Retry Logic:** 2 retries with exponential backoff
- **Rate Limiting:** 60 requests/min, 1000 requests/hour

## Debug Commands

```bash
# Build app
xcodebuild -project SeemiSpiritualCompanion.xcodeproj \
  -scheme SeemiSpiritualCompanion \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,id=46E71B54-6AFE-446D-A4EC-19487DA2BD0C' \
  build

# Run and capture logs
xcrun simctl spawn booted log stream --predicate 'processImagePath contains "Seemi"' --level debug

# Check if model is correct in compiled binary
strings /Users/nexteleven/Seemi/Surah/DerivedData/SeemiSpiritualCompanion-*/Build/Products/Debug-iphonesimulator/SeemiSpiritualCompanion.app/SeemiSpiritualCompanion | grep "grok-"
```
