# 🔒 Security Configuration Guide

## ⚠️ Important Security Notice

The Firebase API keys and Google Sign-In client IDs have been removed from the public repository for security reasons. 

## 🛠️ Setup Instructions

### 1. Environment Variables (Recommended for Production)

Create a `.env` file in the root directory (this file is gitignored):

```env
# Firebase Configuration
FIREBASE_API_KEY=your_firebase_api_key_here
FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_STORAGE_BUCKET=your_project.firebasestorage.app
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_APP_ID=your_app_id
FIREBASE_MEASUREMENT_ID=your_measurement_id

# Google Sign-In
GOOGLE_SIGNIN_CLIENT_ID=your_google_client_id.apps.googleusercontent.com
```

### 2. For Development

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `joki-tugas-app`
3. Go to Project Settings → General
4. Copy your web app configuration
5. Update the configuration in:
   - `lib/config/firebase_config.dart`
   - `web/index.html`

### 3. For Web Deployment

Update `web/index.html` with your actual configuration:

```html
<!-- Google Sign-In Client ID -->
<meta name="google-signin-client_id" content="YOUR_GOOGLE_CLIENT_ID">

<!-- Firebase Configuration -->
<script>
  const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_AUTH_DOMAIN",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_STORAGE_BUCKET",
    messagingSenderId: "YOUR_SENDER_ID",
    appId: "YOUR_APP_ID",
    measurementId: "YOUR_MEASUREMENT_ID"
  };
  
  firebase.initializeApp(firebaseConfig);
</script>
```

## 🔐 Security Best Practices

1. **Never commit API keys** to version control
2. **Use environment variables** for sensitive data
3. **Restrict API key usage** in Firebase Console
4. **Enable App Check** for additional security
5. **Use domain restrictions** for web apps

## 📝 Firebase Security Rules

Make sure to configure proper security rules in Firebase Console:

```javascript
// Firestore Security Rules Example
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 🚨 What to do if keys are compromised

1. **Immediately regenerate** all API keys
2. **Update restrictions** in Firebase/Google Console
3. **Review access logs** for unauthorized usage
4. **Update all deployed applications**

## 📞 Support

If you need help with security configuration, please check:
- [Firebase Security Documentation](https://firebase.google.com/docs/rules)
- [Google Sign-In Security Best Practices](https://developers.google.com/identity/sign-in/web/security)
