# Flutter UI Development Rules

## File and Code Organization
- Use snake_case for file and folder names
- Use PascalCase for class names
- Always check the widgets folder before creating new components
- Prefer editing existing files over creating new ones
- Follow single responsibility principle for all widgets and functions
- Add comprehensive comments explaining widget purpose and usage

## Theming Excellence
- NEVER hardcode colors, fonts, dimensions, or any design tokens
- Access colors exclusively through `Theme.of(context).colorScheme` or custom theme extensions
- Use theme-defined text styles, spacing values, border radius, and shadows
- Implement Material You 3 theming for Android
- Implement iOS-native theming for iOS platform
- Create centralized theme configuration that serves as single source of truth

## Component Development
- Create modular, reusable widgets that can be used across the application
- Separate presentation logic from business logic completely
- Build these specific reusable components for UI demo: Title text, subtitle text, info text, input field, primary button, secondary button, disabled button, dialog box, modal sheet
- Ensure all components respect platform conventions (Cupertino widgets for iOS, Material widgets for Android)

## Platform-Native Implementation
- Use Cupertino action sheets, modals, and dialogs on iOS
- Use Material equivalents on Android
- Implement platform-specific navigation patterns
- Respect platform-specific spacing, typography, and interaction patterns

## API and Data Management
- Create mock API responses in separate files when needed
- In phase 2 we will link with actual APIs - not now
- Focus on UI implementation with mock data

## Quality Standards
- Test components in the UI demo screen to ensure proper theming
- Verify theme consistency across all components
- Ensure components are accessible and follow platform accessibility guidelines
- Validate that no design tokens are hardcoded anywhere in the codebase
- For any screen with text input:
  - Allow tapping anywhere outside the input to close the keyboard
  - When the keyboard is open, move the main content to the top to avoid being covered