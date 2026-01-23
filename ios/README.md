# Nightline iOS App

This folder contains the SwiftUI scaffolding for the Nightline iOS app.

## Quick start (Xcode)

1. Open Xcode and create a new **iOS App** project named `Nightline`.
2. Replace the generated SwiftUI files with the contents of the files in `ios/Nightline/`.
3. Ensure the deployment target is iOS 17 or later.
4. Run the backend locally:

   ```bash
   cd ../backend
   npm install
   npm run prisma:migrate -- --name init
   npm run prisma:seed
   npm run dev
   ```

5. Run the app in the iOS Simulator. The API base URL is set to `http://localhost:4000` in `APIClient.swift`.

## Notes
- The app is wired to the backend for Explore, Live, and Check-in flows.
- Saved and Profile tabs are placeholders for now.
