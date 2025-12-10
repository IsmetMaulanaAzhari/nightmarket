# BookCircle - Second-Hand Books E-Commerce App

A complete Flutter e-commerce application for buying and selling used books, built with Material Design 3 and featuring a warm, cozy bookshop aesthetic.

## Features

### 🏠 Home Page
- Search bar with advanced filtering (genre, price range, condition)
- Category chips for easy browsing
- Featured books carousel with auto-play
- Popular books grid view
- Pull-to-refresh functionality

### 📚 Book Listing & Details
- Detailed book information (title, author, ISBN, condition)
- Multiple image carousel with smooth indicators
- Price with barter option indication
- Seller profile preview with rating
- Comprehensive book description
- Add to cart and wishlist functionality
- Hero animations for smooth transitions

### 🛒 Shopping Cart
- Cart item management with quantity controls
- Real-time price calculation
- Remove items functionality
- Clear all option
- Proceed to checkout

### 💳 Checkout Flow
- Multi-step checkout process:
  1. Shipping address input form
  2. Shipping method selection (Standard/Express/Same Day)
  3. Payment method selection (Bank Transfer/COD)
- Order summary with price breakdown
- Form validation
- Order confirmation

### 👤 User Profile
- Profile information display
- Quick stats (listings, orders, wishlist count)
- My orders - purchase history
- Edit profile functionality
- Settings and help access

### 🏪 Seller Features
- Add new book listing with image picker
- Edit existing listings
- Delete listings
- Mark books as sold
- View listing analytics (views count)
- Manage inventory

### ❤️ Wishlist
- Save favorite books
- Grid view display
- Quick add to cart from wishlist
- Clear all functionality

## Technical Stack

- **Framework**: Flutter (latest stable)
- **State Management**: Provider
- **Navigation**: go_router
- **Local Storage**: 
  - Hive for cart data
  - SharedPreferences for wishlist
- **Image Handling**: 
  - image_picker for uploading
  - cached_network_image for display
- **UI Components**:
  - carousel_slider for featured books
  - smooth_page_indicator for carousels
  - flutter_rating_bar for ratings
- **Utilities**:
  - intl for date/number formatting
  - uuid for ID generation

## Color Scheme

The app features warm, earthy tones to evoke a cozy bookshop feel:
- Primary: Brown (#8B6F47)
- Secondary: Soft Green (#9CAF88)
- Background: Warm White (#FFFBF5)
- Accent: Cream (#F5E6D3)

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── router/
│       └── app_router.dart
├── data/
│   ├── models/
│   │   ├── book.dart
│   │   ├── cart_item.dart
│   │   ├── user.dart
│   │   └── order.dart
│   └── repositories/
│       └── mock_data.dart
├── providers/
│   ├── book_provider.dart
│   ├── cart_provider.dart
│   ├── wishlist_provider.dart
│   ├── order_provider.dart
│   └── user_provider.dart
├── presentation/
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── book_details_screen.dart
│   │   ├── cart_screen.dart
│   │   ├── checkout_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── wishlist_screen.dart
│   │   ├── add_book_screen.dart
│   │   └── my_listings_screen.dart
│   └── widgets/
│       ├── book_card.dart
│       ├── search_filter_sheet.dart
│       └── main_navigation.dart
└── main.dart
```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android Emulator or iOS Simulator (or physical device)

### Installation Steps

1. **Navigate to project directory**
   ```bash
   cd "c:\Kuliah\Semester 5\Pemrograman Sistem Mobile\nightmarket"
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters** (Optional - for full Hive functionality)
   ```bash
   flutter pub run build_runner build
   ```
   
   Note: The app will work without this step as Hive adapters are commented out in main.dart. If you want to enable Hive persistence:
   - Uncomment the `part` directives in model files
   - Uncomment the adapter registrations in `main.dart`
   - Run the build_runner command above

4. **Run the app**
   ```bash
   flutter run
   ```

### For Android
```bash
flutter run -d android
```

### For iOS
```bash
flutter run -d ios
```

### For Web
```bash
flutter run -d chrome
```

## Mock Data

The app includes mock data for demonstration:
- 15+ sample books across various categories
- Mock user profile
- Sample seller profiles with ratings

All data is stored in `lib/data/repositories/mock_data.dart` and can be easily extended.

## Key Features Implementation

### Search & Filter
- Text search across title, author, and description
- Category filtering
- Condition filtering (Like New, Good, Fair)
- Price range filtering
- Combined filter support

### Cart Management
- Persistent storage using Hive
- Quantity increment/decrement
- Real-time price calculation
- Item removal with confirmation

### Navigation
- Bottom navigation bar for main sections
- Deep linking support with go_router
- Smooth page transitions
- Hero animations for images

### Animations
- Carousel auto-play for featured books
- Smooth page indicators
- Card elevation on hover
- Ripple effects on buttons
- Hero transitions between screens

## Payment Methods (Mock)

The app supports:
1. **Bank Transfer** - Users receive bank details after order placement
2. **Cash on Delivery (COD)** - Payment collected upon delivery

*Note: No actual payment processing is implemented.*

## Future Enhancements

Potential features for production:
- [ ] Real authentication system
- [ ] Backend API integration
- [ ] Real-time chat between buyers and sellers
- [ ] Advanced search with Algolia
- [ ] Push notifications for orders
- [ ] Rating and review system
- [ ] Social sharing
- [ ] Multiple language support
- [ ] Dark mode
- [ ] Offline mode with sync

## Troubleshooting

### Common Issues

**Issue**: Hive adapter errors
- **Solution**: Comment out Hive adapter registrations in `main.dart` or run `flutter pub run build_runner build`

**Issue**: Image picker not working
- **Solution**: Ensure proper permissions in AndroidManifest.xml and Info.plist

**Issue**: Navigation errors
- **Solution**: Ensure go_router is properly configured and all routes are defined

## Development Notes

- The app uses mock data for demonstration purposes
- Image picker will use placeholder URLs instead of uploading to a server
- All data is stored locally and will persist across app restarts (when Hive is properly configured)
- No actual payment gateway is integrated

## License

This project is created for educational purposes.

## Contributors

Created as part of Mobile System Programming coursework.

---

**BookCircle** - Give Books a Second Life 📚
