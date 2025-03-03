App 1: SpaceX Launch Data Viewer
Models:

Launch model to represent SpaceX launch data
Rocket model to represent SpaceX rocket data
Payload model to represent payload information

Services:

SpaceXApi service to fetch data from the SpaceX REST API

State Management:

LaunchesProvider using the Provider package for state management
Filtering functionality for launches (by status and year)

UI Components:

LaunchListItem widget for displaying a launch in the list
LaunchFilter widget for filtering launches
LaunchesScreen for displaying the list of launches
LaunchDetailsScreen for displaying detailed information about a selected launch

App Setup:

Main app configuration with theme settings
Support for both light and dark themes

Features:

Two main screens: a launches list screen and a launch details screen
Fetches and displays SpaceX launch data from the SpaceX REST API
Shows basic launch information in the list and detailed information on the details screen
Allows users to filter launches by status (past/upcoming, successful/failed) and by year
Handles loading states and network errors gracefully
Responsive layout that works on different device sizes
Follows Material Design guidelines

Running the App:

Install Flutter following the instructions in the README
Clone the repository
Run flutter pub get to install dependencies
Run flutter run to start the app
