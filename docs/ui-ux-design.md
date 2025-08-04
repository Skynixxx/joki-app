# 🎨 UI/UX Design Documentation

## Design Philosophy

Aplikasi Joki Tugas menggunakan Material Design 3 dengan pendekatan modern dan user-friendly yang mengutamakan kemudahan penggunaan dan aksesibilitas.

## Design System

### Color Palette

```dart
// Primary Colors
static const Color primary = Color(0xFF6B73FF);
static const Color primaryLight = Color(0xFF9B59B6);
static const Color primaryDark = Color(0xFF4C63D2);

// Gradients
static const LinearGradient primaryGradient = LinearGradient(
  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Status Colors
static const Color success = Color(0xFF48BB78);
static const Color error = Color(0xFFE53E3E);
static const Color warning = Color(0xFFED8936);
```

### Typography

Menggunakan **Poppins** font family dengan hierarki yang jelas:

```dart
// Headlines
static const TextStyle headline1 = TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
static const TextStyle headline2 = TextStyle(fontSize: 28, fontWeight: FontWeight.bold);
static const TextStyle headline3 = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
static const TextStyle headline4 = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);

// Body Text
static const TextStyle bodyLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
static const TextStyle bodyMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.normal);
static const TextStyle bodySmall = TextStyle(fontSize: 12, fontWeight: FontWeight.normal);
```

### Spacing System

```dart
// Consistent spacing scale
static const double paddingXS = 4.0;
static const double paddingS = 8.0;
static const double paddingM = 16.0;
static const double paddingL = 24.0;
static const double paddingXL = 32.0;
static const double paddingXXL = 48.0;
```

### Border Radius

```dart
static const double radiusS = 8.0;
static const double radiusM = 12.0;
static const double radiusL = 16.0;
static const double radiusXL = 20.0;
static const double radiusXXL = 24.0;
```

## Screen Designs

### 1. Splash Screen

**Purpose:** Branding dan loading aplikasi
**Key Features:**

- Animated logo dengan rotasi dan scale
- Gradient background yang eye-catching
- Loading indicator dengan text feedback
- Smooth transition ke auth screen

**Animations:**

- Logo: Scale + Rotation (2 detik)
- Text: Fade in + Slide Y dengan stagger
- Shimmer effect pada app name

### 2. Authentication Screen

**Purpose:** Login dan registrasi user
**Key Features:**

- Tab-based navigation (Login/Register)
- Form validation real-time
- Social login buttons (Google)
- Forgot password integration
- Gradient background dengan card overlay

**Interaction Design:**

- Smooth tab transitions
- Password visibility toggle
- Loading states untuk semua actions
- Error handling dengan snackbar

### 3. Home Screen

**Purpose:** Dashboard utama aplikasi
**Key Features:**

- Bottom navigation (Dashboard, Orders, Profile)
- Welcome header dengan user info
- Stats cards untuk metrics
- Service grid dengan layanan
- Recent orders list

**Layout Structure:**

```
┌─ Header (User Info + Notifications)
├─ Stats Cards (Completed/In Progress)
├─ Services Grid (4 services)
└─ Recent Orders List
```

### 4. Forgot Password Screen

**Purpose:** Reset password functionality
**Key Features:**

- Email input dengan validasi
- Loading dan success states
- Error handling yang user-friendly
- Responsive design
- Consistent branding

## Component Library

### 1. Input Fields

```dart
Widget _buildInputField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  bool isPassword = false,
  String? Function(String?)? validator,
})
```

**Features:**

- Consistent styling
- Icon integration
- Password visibility toggle
- Real-time validation
- Error states

### 2. Gradient Buttons

```dart
Widget _buildGradientButton({
  required String text,
  required VoidCallback onPressed,
})
```

**Features:**

- Primary gradient background
- Consistent height (AppSizes.inputL)
- Rounded corners
- Loading states support

### 3. Social Login Buttons

```dart
Widget _buildSocialButton({
  required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onPressed,
})
```

**Features:**

- White background dengan border
- Brand-colored icons
- Consistent sizing
- Hover effects

### 4. Cards dan Containers

```dart
static BoxDecoration cardDecoration = BoxDecoration(
  color: AppColors.backgroundCard,
  borderRadius: BorderRadius.circular(AppSizes.radiusM),
  boxShadow: [
    BoxShadow(
      color: AppColors.shadowLight,
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ],
);
```

## Animation System

### 1. Flutter Animate Integration

Menggunakan `flutter_animate` package untuk:

- Entrance animations
- Loading states
- Page transitions
- Micro-interactions

### 2. Animation Patterns

```dart
// Stagger animations
.animate().fadeIn(delay: 100.ms).slideY(begin: 0.3)

// Loading animations
.animate().scale(delay: 200.ms, duration: 600.ms)

// Shimmer effects
.animate().shimmer(duration: 1200.ms, color: Colors.white54)
```

### 3. Performance Considerations

- Menggunakan `AnimationController` untuk kompleks animations
- Lazy loading untuk heavy animations
- Dispose controllers dengan proper lifecycle

## Responsive Design

### 1. Breakpoints

```dart
// Screen size helpers
static bool isMobile(BuildContext context) => width < 600;
static bool isTablet(BuildContext context) => width >= 600 && width < 1200;
static bool isDesktop(BuildContext context) => width >= 1200;
```

### 2. Adaptive Layouts

- Mobile-first approach
- Flexible grid systems
- Responsive padding dan margins
- Adaptive font sizes

### 3. Safe Area Handling

```dart
return SafeArea(
  child: SingleChildScrollView(
    padding: AppHelpers.getResponsivePadding(context),
    child: content,
  ),
);
```

## Accessibility Features

### 1. Screen Reader Support

- Semantic labels untuk semua interactive elements
- Proper heading hierarchy
- Form field labels dan hints

### 2. Color Contrast

- WCAG AA compliance untuk text contrast
- Alternative indicators selain color
- High contrast mode support

### 3. Touch Targets

- Minimum 44px touch targets
- Adequate spacing between interactive elements
- Easy thumb reach zones

## Dark Mode Support (Future)

### 1. Color Scheme

```dart
// Planned dark mode colors
static const Color darkBackground = Color(0xFF121212);
static const Color darkSurface = Color(0xFF1E1E1E);
static const Color darkPrimary = Color(0xFF8A91FF);
```

### 2. Adaptive Components

- Theme-aware color selection
- Context-based icon variants
- Dynamic gradients

## Performance Optimization

### 1. Image Optimization

- WebP format untuk web
- Proper sizing dan compression
- Lazy loading untuk images

### 2. Animation Performance

- `RepaintBoundary` untuk complex widgets
- `AnimatedBuilder` untuk efficient rebuilds
- GPU-accelerated animations

### 3. State Management

- Minimal rebuilds dengan proper state scoping
- Efficient list rendering
- Memory management untuk large datasets

## Design Tokens

### 1. Elevation System

```dart
// Shadow levels
static Color shadowLight = Colors.black.withOpacity(0.1);
static Color shadowMedium = Colors.black.withOpacity(0.2);
static Color shadowDark = Colors.black.withOpacity(0.3);
```

### 2. Icon System

- FontAwesome untuk consistency
- 20px default size untuk navigation
- 24px untuk primary actions
- 16px untuk secondary actions

### 3. Loading States

- Consistent spinner styles
- Loading text feedback
- Skeleton screens untuk content loading

## Brand Guidelines

### 1. Logo Usage

- Primary logo dengan proper spacing
- Minimum size requirements
- Color variations
- Background considerations

### 2. Voice dan Tone

- Friendly dan approachable
- Professional namun casual
- Indonesian language optimization
- Error messages yang helpful

### 3. Imagery Style

- Clean dan modern
- Consistent color treatment
- Professional photography
- Icon consistency

## Testing Guidelines

### 1. Visual Testing

- Screenshot testing untuk regressions
- Cross-platform consistency
- Different screen sizes
- Accessibility testing

### 2. User Testing

- Usability testing sessions
- A/B testing untuk UI changes
- Performance benchmarking
- Accessibility audits

## Tools dan Resources

### 1. Design Tools

- Figma untuk design specs
- Adobe Illustrator untuk icons
- Principle untuk prototyping

### 2. Development Tools

- Flutter Inspector untuk debugging
- Performance profiler
- Accessibility scanner

### 3. Asset Management

- SVG icons untuk scalability
- Optimized images
- Font loading optimization

## Future Enhancements

### 1. Advanced Animations

- Lottie animations
- Custom path animations
- Physics-based animations
- Gesture-driven interactions

### 2. Enhanced Theming

- Dynamic color dari wallpaper
- Custom theme builder
- Advanced dark mode
- High contrast themes

### 3. Accessibility

- Voice navigation
- Gesture shortcuts
- Advanced screen reader support
- Disability-specific optimizations
