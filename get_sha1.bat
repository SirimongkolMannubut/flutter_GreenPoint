@echo off
echo Getting SHA-1 fingerprint for debug keystore...
keytool -list -v -alias androiddebugkey -keystore "%USERPROFILE%\.android\debug.keystore" -storepass android -keypass android
pause