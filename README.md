# Food-Inspired E-Commerce App (Flutter)

A fully functional e-commerce mobile app built with Flutter, using the
[Fake Store API](https://fakestoreapi.com) for products, users, and auth.

## Design note
UI is styled after a food-delivery mockup (warm color palette, rounded
cards), but all data is real e-commerce data from Fake Store API
(electronics, jewelry, men's/women's clothing) — no food-specific data
exists in the API, so product categories and fields reflect what the
API actually returns.

## Architecture
Feature-first structure with clean separation:
- `core/` — constants, network client, error handling, routing, utils
- `data/` — models, repositories, remote (Dio) and local (Hive) datasources
- `presentation/` — one folder per feature (auth, products, cart, profile),
  each with screens/widgets/providers

## State management
Riverpod — StateNotifierProvider for cart/auth (mutable app state),
FutureProvider for product fetching (async read-only data), with derived
Provider for client-side filtering.

## Features implemented
- Login via Fake Store `/auth/login`, session persisted in Hive
- Product grid from `/products`, category filter, live search
- Product details with quantity selector
- Cart with quantity management, persisted in Hive across restarts
- Profile screen from `/users`, with logout
- Loading / empty / error states throughout
- Responsive grid (2/3/4 columns based on screen width)

## Known limitations
- Fake Store API's login doesn't return a user profile, so we match
  the logged-in username against `/users` — if seeded data changes
  upstream this fallback logic may need adjusting
- Checkout is a stub (out of scope per assignment)

## Test credentials
Username: `mor_2314`
Password: `83r5^_`

## Setup
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```
