# E2E Test Script for Chatbot

## Pre-Test Checklist
- [ ] App built successfully (`BUILD SUCCEEDED`)
- [ ] Model set to: `grok-4-1-fast-reasoning`
- [ ] Simulator booted and ready
- [ ] Console logs monitoring enabled

## Test Steps

### 1. Install App in Simulator
```bash
xcrun simctl install 46E71B54-6AFE-446D-A4EC-19487DA2BD0C \
  DerivedData/Build/Products/Debug-iphonesimulator/SeemiSpiritualCompanion.app
```

### 2. Launch App
```bash
xcrun simctl launch 46E71B54-6AFE-446D-A4EC-19487DA2BD0C \
  com.seemi.spiritual.companion
```

### 3. Monitor Console Logs
```bash
xcrun simctl spawn booted log stream \
  --predicate 'processImagePath contains "SeemiSpiritualCompanion"' \
  --level debug \
  --style compact
```

### 4. Expected Log Sequence (Success Path)

When user sends a message:

1. **Initialization:**
   ```
   XAIAPIService initialized - API key must be configured in Settings
   ```
   OR
   ```
   XAIAPIService initialized - API key configured
   ```

2. **Message Send:**
   ```
   Initiating API request to https://api.x.ai/v1/chat/completions with model: grok-4-1-fast-reasoning
   Request body - messages count: X, max_tokens: 4000
   ```

3. **Success Response:**
   ```
   API Response received
   Content length: XXX characters
   ```

4. **Failure Response (if API key missing):**
   ```
   API Error: API key not configured
   HTTP Status Code: 401
   ```

### 5. Test Scenarios

#### Scenario A: No API Key
**Action:** Send message without configuring API key
**Expected:**
- Error message in chat: "Please configure your API key in Settings → AI Settings"
- Console: `API Key not configured - user must add key in Settings → AI Settings`
- HTTP Status: 401 or no request sent

#### Scenario B: Invalid API Key
**Action:** Configure invalid API key, send message
**Expected:**
- Error message in chat: "Invalid API key. Please check your key in Settings."
- Console: `HTTP Status Code: 401`
- Console: `Unauthorized - invalid API key or model name`

#### Scenario C: Valid API Key, Wrong Model
**Action:** Use valid key but wrong model name (if we had wrong model)
**Expected:**
- Error message in chat: Error details
- Console: `HTTP Status Code: 404` or `400`
- Console: `Not Found - check API endpoint and model name. Current model: grok-4-1-fast-reasoning`

#### Scenario D: Valid API Key, Correct Model ✅
**Action:** Configure valid key, send "Hello"
**Expected:**
- Message appears in chat
- Bot response appears after ~2-5 seconds
- Console: `API Response received`
- Console: `Content length: XXX characters`
- HTTP Status: 200

### 6. Verify Model Name in Running App

To verify the model being used in the actual request:
```bash
# Watch for API request logs
xcrun simctl spawn booted log stream \
  --predicate 'message contains "grok" OR message contains "model:" OR message contains "api.x.ai"' \
  --level debug
```

Look for line containing:
```
Initiating API request to https://api.x.ai/v1/chat/completions with model: grok-4-1-fast-reasoning
```

### 7. Manual Testing Steps

1. **Open App in Simulator**
2. **Navigate to Settings → AI Settings**
3. **Enter API Key** (if not configured)
4. **Go to Chat Tab**
5. **Send Test Message:** "Hello"
6. **Observe:**
   - Console logs show correct model
   - Response appears in chat
   - No error messages

### 8. Expected Behavior

✅ **Success Indicators:**
- Model name in logs: `grok-4-1-fast-reasoning`
- HTTP 200 response
- Bot message appears in UI
- No errors in console

❌ **Failure Indicators:**
- Model name wrong or missing
- HTTP 401/404/400 errors
- Empty response
- Timeout errors

---

## Quick Test Command

```bash
# Full test in one go
cd /Users/nexteleven/Seemi/Surah && \
  xcodebuild -project SeemiSpiritualCompanion.xcodeproj \
    -scheme SeemiSpiritualCompanion \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,id=46E71B54-6AFE-446D-A4EC-19487DA2BD0C' \
    build && \
  xcrun simctl install 46E71B54-6AFE-446D-A4EC-19487DA2BD0C \
    DerivedData/Build/Products/Debug-iphonesimulator/SeemiSpiritualCompanion.app && \
  echo "✅ App installed. Now launch and test chatbot in simulator UI"
```
