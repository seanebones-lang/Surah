# Chatbot Troubleshooting Guide
**Issue:** Chatbot never answers  
**Date:** January 2026

---

## 🔍 Diagnosis Steps

### **1. Check API Key**
- Go to Settings → AI Settings
- Verify API key is configured
- Key should start with `xai-`
- Test key at https://console.x.ai

### **2. Verify Model Name**
Current model in code: `grok-beta` ✅

**Available xAI Models (as of 2026):**
- `grok-beta` - Stable default model (RECOMMENDED)
- `grok-2-1212` - Latest model (if available)
- `grok-2-vision-1212` - Vision model
- `grok-2-1212-preview` - Preview version

**To change model:**
Edit `Services/XAIAPIService.swift` line 17:
```swift
private let model = "grok-2-1212" // or your preferred model
```

**Note:** Invalid model names (like "grok-4-1-fast-reasoning") will cause 400/404 errors.

### **3. Check API Endpoint**
Current endpoint: `https://api.x.ai/v1`

Verify at: https://docs.x.ai

### **4. Check Error Logs**
The app now logs detailed error information:
- HTTP status codes
- Response data
- Model name used
- Request details

**To view logs:**
1. Run app in Xcode
2. Check Console output
3. Look for "API Error" messages

### **5. Common Issues**

#### **Issue: 401 Unauthorized**
- **Cause:** Invalid API key
- **Fix:** Update API key in Settings → AI Settings
- **Verify:** Check key at console.x.ai

#### **Issue: 404 Not Found**
- **Cause:** Wrong model name or endpoint
- **Fix:** Update model name to valid one (see above)
- **Verify:** Check xAI docs for current models

#### **Issue: 400 Bad Request**
- **Cause:** Invalid request format
- **Fix:** Check request body format matches xAI API spec
- **Verify:** Compare with xAI API documentation

#### **Issue: No Response (Timeout)**
- **Cause:** Network issues or API down
- **Fix:** Check internet connection, verify xAI API status
- **Verify:** Test API at console.x.ai

---

## 🛠️ Quick Fixes

### **Fix 1: Update Model Name**
If `grok-beta` doesn't work, try:
```swift
private let model = "grok-2-1212"
```

### **Fix 2: Verify API Key**
1. Go to https://console.x.ai
2. Check API key is active
3. Verify credits/usage limits
4. Update key in app if needed

### **Fix 3: Test API Directly**
Use curl to test:
```bash
curl https://api.x.ai/v1/chat/completions \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "grok-beta",
    "messages": [{"role": "user", "content": "Hello"}]
  }'
```

---

## 📝 Enhanced Error Logging

The app now logs:
- ✅ HTTP status codes
- ✅ Response data (first 500 chars)
- ✅ Model name used
- ✅ Request details
- ✅ Error descriptions

**Check Xcode Console for detailed error messages.**

---

## ✅ Verification Checklist

- [ ] API key configured in Settings
- [ ] API key is valid (test at console.x.ai)
- [ ] Model name is correct (check xAI docs)
- [ ] Internet connection active
- [ ] Check Xcode console for error messages
- [ ] Verify API endpoint is correct
- [ ] Check rate limits not exceeded
- [ ] Verify API key has credits

---

**Next Steps:**
1. Check Xcode console for specific error
2. Verify API key at console.x.ai
3. Test with different model name if needed
4. Check xAI API status page
