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
The app meets all the requirements specified in the assignment:
It has two main screens: a launches list screen and a launch details screen
It fetches and displays SpaceX launch data from the SpaceX REST API
It shows basic launch information in the list and detailed information on the details screen
It allows users to filter launches by status (past/upcoming, successful/failed) and by year
It handles loading states and network errors gracefully
It has a responsive layout that works on different device sizes
It follows Material Design guidelines
To run this app, you would need to:
Install Flutter following the instructions in the README
Clone the repository
Run flutter pub get to install dependencies
Run flutter run to start the app
The app provides a clean and intuitive user interface for exploring SpaceX launches, with proper error handling and loading states. It also includes additional features like viewing rocket details and payload information.