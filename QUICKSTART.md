# BookCircle - Quick Start Guide

## 🚀 Get Started in 3 Steps

### 1. Install Dependencies
```bash
cd "c:\Kuliah\Semester 5\Pemrograman Sistem Mobile\nightmarket"
flutter pub get
```

### 2. Run the App
```bash
flutter run
```

That's it! The app should now be running on your device/emulator.

## 📱 First Look

When the app launches, you'll see:
- **Home Screen** with featured books carousel and category filters
- **Bottom Navigation** with Home, Cart, and Profile tabs
- Sample book data ready to explore

## 🎯 Try These Features

### Browse Books
1. Scroll through featured books carousel
2. Tap category chips to filter
3. Use search bar to find specific books
4. Tap on any book to view details

### Shopping
1. Open a book → Tap "Add to Cart"
2. Go to Cart tab (bottom navigation)
3. Adjust quantities with +/- buttons
4. Tap "Proceed to Checkout"
5. Fill shipping info → Select shipping method → Choose payment
6. Complete order!

### Wishlist
1. Tap heart icon on any book card
2. Access wishlist from Home screen (heart icon in app bar)
3. View all your saved books

### Seller Features
1. Go to Profile tab
2. Tap "My Listings"
3. Tap the green "Add Book" button
4. Fill in book details and add photos
5. List your book!

## 🎨 App Navigation

```
├── Home (/)
│   ├── Book Details (/book/:id)
│   ├── Wishlist (/wishlist)
│   └── Search & Filters
│
├── Cart (/cart)
│   └── Checkout (/checkout)
│       └── Order Confirmation
│
└── Profile (/profile)
    ├── My Listings (/my-listings)
    │   ├── Add Book (/add-book)
    │   └── Edit Book (/edit-book/:id)
    ├── Orders (coming soon)
    └── Settings
```

## 💡 Tips

- **Mock Data**: The app uses sample data. Your changes (cart, wishlist) persist locally.
- **Images**: When adding books, image picker shows placeholder images.
- **Payment**: No real payment processing - just demonstrates the flow.
- **Navigation**: Use device back button or app navigation to move between screens.

## 🐛 Troubleshooting

### App won't build?
```bash
flutter clean
flutter pub get
flutter run
```

### No emulator available?
```bash
flutter devices
flutter emulators
flutter emulators --launch <emulator_id>
```

### Hot reload not working?
Press `r` in terminal or `Ctrl+S` in your code editor

## 📚 Learn More

See [README.md](README.md) for:
- Complete feature list
- Technical architecture
- Development notes
- Future enhancements

## 🎯 Next Steps

1. **Explore the code** - Well-organized structure in `lib/`
2. **Customize** - Easy to modify colors, add categories, etc.
3. **Extend** - Add your own features using the existing patterns
4. **Deploy** - Build for Android/iOS when ready

---

Happy coding! 🎉

**BookCircle** - Give Books a Second Life 📚
