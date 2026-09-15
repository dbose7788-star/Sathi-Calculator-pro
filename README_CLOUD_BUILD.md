# Sathi — Cloud APK Build

## Build with GitHub Actions from Android
1. Create a GitHub repository named `sathi-calculator`.
2. Upload the contents of this folder to the repository root.
3. Open **Actions** → **Build Sathi APK**.
4. Tap **Run workflow**.
5. Wait for the build to finish.
6. Open the completed workflow run and download the artifact **sathi-release-apk**.
7. Extract the ZIP and install `app-release.apk` on your Android phone.

The workflow builds a release APK in the cloud; no Flutter SDK is required on the phone.
