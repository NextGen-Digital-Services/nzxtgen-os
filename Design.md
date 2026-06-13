# Design System & Aesthetics (Design.md)

This document establishes the UI/UX rules, design tokens, and aesthetic principles that govern the visual language of NZXTGEN OS. The project follows a premium, dark luxury theme inspired by Apple's digital design syntax, combining glassmorphism with high-contrast glowing elements.

---

## 1. Color System

To achieve depth and visual excellence, colors are defined as HSL tokens with exact HEX values. Avoid generic colors.

| Token | Color Name | HEX Code | HSL / Opacity | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| `primary` | Electric Cyan | `#00E5FF` | `hsl(186, 100%, 50%)` | Highlighting critical actions, selection states, active links. |
| `secondary` | Deep Purple | `#9D4EDD` | `hsl(273, 67%, 58%)` | Brand accents, decorative highlights, secondary button states. |
| `background` | Rich Dark Navy | `#0B0C10` | `hsl(228, 41%, 6%)` | Core app canvas background. Solid, non-reflective. |
| `surface` | Midnight Ice | `#12141D` | `hsl(229, 23%, 9%)` | Backplate for cards, panels, and input fields. |
| `accent` | Soft Blue Glow | `#00F0FF` | `hsl(184, 100%, 50%, 0.15)`| Ambient radial gradients, hover overlays, selection halos. |
| `text-primary`| Geist White | `#F8F9FA` | `hsl(210, 17%, 98%)` | Primary titles, headlines, table values. |
| `text-muted` | Muted Silver | `#8A92A6` | `hsl(222, 11%, 59%)` | Body copy, secondary descriptions, labels. |
| `border-glass`| Frost Border | `#FFFFFF` | `rgba(255, 255, 255, 0.08)`| Micro-borders for glass cards to catch ambient lighting. |

---

## 2. Typography

We use two Google Fonts to establish hierarchy:
- **Primary Headings**: **Geist Sans** (or **Geist Mono** for metadata/code blocks) – a premium, technical geometric sans-serif.
- **Body & Operations UI**: **Inter** – clean, highly readable at micro-scales, optimized for accessibility.

### 2.1 Text Style Definitions
```dart
static const TextStyle displayTitle = TextStyle(
  fontFamily: 'Geist',
  fontWeight: FontWeight.w800,
  fontSize: 32.0,
  letterSpacing: -1.0,
  color: textPrimary,
);

static const TextStyle cardHeader = TextStyle(
  fontFamily: 'Geist',
  fontWeight: FontWeight.w600,
  fontSize: 18.0,
  letterSpacing: -0.5,
  color: textPrimary,
);

static const TextStyle bodyText = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w400,
  fontSize: 14.0,
  height: 1.5,
  color: textMuted,
);

static const TextStyle buttonLabel = TextStyle(
  fontFamily: 'Inter',
  fontWeight: FontWeight.w600,
  fontSize: 14.0,
  letterSpacing: 0.5,
  color: textPrimary,
);
```

---

## 3. Core Design Rules

### 3.1 Selective Glassmorphism
Glassmorphism is used to create visual hierarchy and depth. It must not be applied indiscriminately. 
- **Rule**: Backgrounds of glass containers must use a backdrop filter blur, a semi-transparent dark surface color, and a micro-border.
- **Glass Container Construction Recipe**:
```dart
Widget buildGlassCard({required Widget child}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16.0),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x12141D).withOpacity(0.65), // Midnight Ice translucent
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Colors.white.withOpacity(0.08), // Frost Border
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 24.0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: child,
      ),
    ),
  );
}
```

### 3.2 Premium Spacing System
All margins, padding, gaps, and sizes must conform to a strict 8px grid system. No arbitrary padding (e.g. 13px, 19px) is permitted.
- **Micro-gaps**: `4px` or `8px` – for icons, labels, or inline elements.
- **Standard Spacing**: `16px` – default padding inside cards, list views, and text blocks.
- **Layout Spacing**: `24px` or `32px` – margins between cards, sections, and page borders.
- **Section Spacing**: `48px` or `64px` – separation between major header blocks or checkout panels.

### 3.3 Apple-Inspired Visual Hierarchy
- **Depth Map**: Background (deepest) -> Ambient Glow Gradient -> Glass Surface Card -> Hover Active State (glowing border or accent background).
- **Corner Radii**: 
  - Standard buttons and text fields: `12px`
  - Cards, panels, and bottom navigation: `16px` or `24px`
  - Large modal dialogs: `32px`
- **Drop Shadows**: Smooth, diffused, non-muddy shadows. Utilize light sources from the top-middle (`Offset(0, 8)`) with blur radius double the offset.

### 3.4 Accessibility (A11y) Rules
- **Contrast Ratios**: Body text on Rich Dark Navy background must maintain a contrast ratio of at least 4.5:1. Primary titles must exceed 7:1.
- **Interactive Targets**: Minimum clickable/tap target size is **48px x 48px** for all buttons, menu links, and interactive elements.
- **Semantic Feedback**: Include focus states, disabled states, and dynamic screen reader support (Semantics labels in Flutter).

### 3.5 Responsive Behavior
The application must scale cleanly across Web, Desktop, and Mobile.
- **Breakpoints**:
  - **Mobile**: `< 600px` – Single column layouts, bottom navigation bar.
  - **Tablet**: `600px - 1024px` – Multi-column grids (2 columns), collapsible navigation rail.
  - **Desktop / Web**: `> 1024px` – Wide dashboard grid (3 columns), permanent left sidebar.
- **Layout Rule**: Grid structures must use flexible, auto-fitting sizing patterns rather than hard-coded widths.

### 3.6 Micro-Animations & Motion Design
Animations must feel responsive, swift, and clean. Avoid long, heavy transitions.
- **Standard Hover Duration**: `200ms` using `Curves.easeInOut`.
- **Page Transitions**: `350ms` using `Curves.easeOutCubic`.
- **System Feedback (Success/Notification)**: Spring-loaded curves (e.g. `Curves.elasticOut`).
- **Interactive States**: Elevate cards by `2px` and brighten borders on hover/focus.
```dart
// Example of Hover State Transition
AnimatedContainer(
  duration: const Duration(milliseconds: 200),
  curve: Curves.easeInOut,
  transform: _isHovered ? (Matrix4.identity()..translate(0, -2)) : Matrix4.identity(),
  decoration: BoxDecoration(
    border: Border.all(
      color: _isHovered ? electricCyan : Colors.white.withOpacity(0.08),
    ),
  ),
  child: cardChild,
)
```
