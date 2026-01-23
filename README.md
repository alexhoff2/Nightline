# Nightline

Nightline is an iOS-first nightlife companion that helps people decide where to go by showing live crowd signals, amenities, and vibe details.

## Repository layout

- `backend/` - Express + Prisma API service (SQLite for local development).

## Backend setup

1. Create an environment file:

   ```bash
   cp backend/.env.example backend/.env
   ```

2. Install dependencies:

   ```bash
   cd backend
   npm install
   ```

3. Initialize the database and seed sample data:

   ```bash
   npm run prisma:migrate -- --name init
   npm run prisma:seed
   ```

4. Start the API server:

   ```bash
   npm run dev
   ```

The API runs at `http://localhost:4000` by default.

## API endpoints

- `GET /health` - Health check
- `GET /bars` - List bars
- `GET /bars/:id` - Bar detail with recent check-ins
- `POST /checkins` - Create a check-in
- `GET /live` - Recent check-ins feed
- `GET /bars/:id/trend?hours=3` - Crowd trend data

## Next steps

- Build SwiftUI app scaffold that matches the Explore, Live, Check-in, Saved, and Profile tabs.
- Connect the iOS client to the API for live crowd updates.
- Add auth + role management for bar owners and verified reporters.
