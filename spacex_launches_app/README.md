# SpaceX Launches App

A cross-platform mobile application (Android/iOS) that displays information about SpaceX rocket launches.

## Features

- View a list of past and upcoming SpaceX launches
- See detailed information about each launch
- Filter launches by status (past/upcoming), success, and year
- Responsive UI that works on different device sizes
- Proper error handling and loading states

## Technologies Used

- Flutter for cross-platform mobile development
- Provider for state management
- HTTP package for API integration
- Cached Network Image for efficient image loading
- Shared Preferences for storing user preferences
- Intl package for date formatting

## Setup Instructions

1. **Install Flutter**
   - Follow the official Flutter installation guide: https://flutter.dev/docs/get-started/install
   - Verify installation with `flutter doctor`

2. **Clone the repository**
   ```
   git clone https://github.com/yourusername/spacex_launches_app.git
   cd spacex_launches_app
   ```

3. **Install dependencies**
   ```
   flutter pub get
   ```

4. **Run the app**
   ```
   flutter run
   ```

## Project Structure

- `lib/models/` - Data models
- `lib/screens/` - UI screens
- `lib/services/` - API and data services
- `lib/widgets/` - Reusable UI components
- `lib/providers/` - State management

## API Information

The app uses the SpaceX REST API:
- Endpoint for all launches: https://api.spacexdata.com/v4/launches
- Endpoint for a specific launch: https://api.spacexdata.com/v4/launches/{id}
- Endpoint for rockets: https://api.spacexdata.com/v4/rockets/{rocket_id}

## Challenges Faced

- Handling complex nested JSON data from the SpaceX API
- Implementing efficient filtering and search functionality
- Creating a responsive UI that works well on different device sizes

## Future Improvements

- Add a rocket section to explore SpaceX rockets
- Implement a search functionality
- Create a "favorites" feature to bookmark launches
- Add notifications for upcoming launches
- Implement offline support with cached data
- Add animations or transitions between screens
- Include countdown timers for upcoming launches 